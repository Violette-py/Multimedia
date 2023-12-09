/** 
 * @file cio.c
 * @brief memory manager and operations for compressing JPEG IO.
 */

#include <string.h>
#include "cjpeg.h"
#include "cio.h"


/*
 * flush input and output of compress IO.
 */


bool
flush_cin_buffer(void *cio)
{
    mem_mgr *in = ((compress_io *) cio)->in;
    size_t len = in->end - in->set;
    memset(in->set, 0, len);
    if (fread(in->set, sizeof(UINT8), len, in->fp) != len)
        return false;
    fseek(in->fp, -len * 2, SEEK_CUR);  // NOTE
    in->pos = in->set;
    return true;
}

bool
flush_cout_buffer(void *cio)
{
    mem_mgr *out = ((compress_io *) cio)->out;
    size_t len = out->pos - out->set;
    if (fwrite(out->set, sizeof(UINT8), len, out->fp) != len)
        return false;
    memset(out->set, 0, len);
    out->pos = out->set;
    return true;
}


/*
 * init memory manager.
 */

void
init_mem(compress_io *cio,
         FILE *in_fp, int in_size, FILE *out_fp, int out_size)
{
    cio->in = (mem_mgr *) malloc(sizeof(mem_mgr));
    if (!cio->in)
        err_exit(BUFFER_ALLOC_ERR);
    cio->in->set = (UINT8 *) malloc(sizeof(UINT8) * in_size);
    if (!cio->in->set)
        err_exit(BUFFER_ALLOC_ERR);
    cio->in->pos = cio->in->set;
    cio->in->end = cio->in->set + in_size;
    cio->in->flush_buffer = flush_cin_buffer;
    cio->in->fp = in_fp;

    cio->out = (mem_mgr *) malloc(sizeof(mem_mgr));
    if (!cio->out)
        err_exit(BUFFER_ALLOC_ERR);
    cio->out->set = (UINT8 *) malloc(sizeof(UINT8) * out_size);
    if (!cio->out->set)
        err_exit(BUFFER_ALLOC_ERR);
    cio->out->pos = cio->out->set;
    cio->out->end = cio->out->set + out_size;
    cio->out->flush_buffer = flush_cout_buffer;
    cio->out->fp = out_fp;

    cio->temp_bits.len = 0;
    cio->temp_bits.val = 0;
}

void
free_mem(compress_io *cio)
{
    fflush(cio->out->fp);
    free(cio->in->set);
    free(cio->out->set);
    free(cio->in);
    free(cio->out);
}


/*
 * write operations.
 */

void
write_byte(compress_io *cio, UINT8 val)
{
    mem_mgr *out = cio->out;
    *(out->pos)++ = val & 0xFF;
    if (out->pos == out->end) {
        if (!(out->flush_buffer)(cio))
            err_exit(BUFFER_WRITE_ERR);
    }
}

void
write_word(compress_io *cio, UINT16 val)
{
    write_byte(cio, (val >> 8) & 0xFF);
    write_byte(cio, val & 0xFF);
}

void
write_marker(compress_io *cio, JPEG_MARKER mark)
{
    write_byte(cio, 0xFF);
    write_byte(cio, (int) mark);
}

void
write_bits(compress_io *cio, BITS bits)
{
    //* TODO
    /******************************************************/

    BITS temp = bits;
    int len = bits.len;
    
    while (len > 0) {
        // 计算需要写入的位数
        int write_len = MIN(8 - cio->temp_bits.len, len);
        // 去除待写入数据开始的0位，与cio中的临时变量并在一起
        cio->temp_bits.val |= ((temp.val >> (len - write_len)) & MASK(write_len)) << (8 - cio->temp_bits.len - write_len);
        // 更新已写入的位数
        cio->temp_bits.len += write_len;
        len -= write_len;

        // 如果临时变量满8位，将其写入输出流
        if (cio->temp_bits.len == 8) {
            // 判断是否需要插入 0x00
            if (cio->temp_bits.val == 0xFF) {
                write_byte(cio, 0xFF);
                write_byte(cio, 0);
            } else {
                write_byte(cio, cio->temp_bits.val);
            }

            cio->temp_bits.len = 0;
            cio->temp_bits.val = 0;
        }
    }
    
    /******************************************************/
}

void
write_align_bits(compress_io *cio) 
{
    //* TODO
    /******************************************************/

    // 对数据区末尾不满1个字节的数据后填充1，凑满1个字节并写入

    // 计算需要填充的位数
    int padding_bits = 8 - cio->temp_bits.len;
    if (padding_bits < 8) {
        // 填充 '1' 位
        cio->temp_bits.val |= MASK(padding_bits);
        write_byte(cio, cio->temp_bits.val);

        // 如果填充的字节是 0xFF，需要插入 0x00
        if (cio->temp_bits.val == 0xFF) {
            write_byte(cio, 0x00);
        }
    }
    cio->temp_bits.len = 0;
    cio->temp_bits.val = 0;

    /******************************************************/
}

