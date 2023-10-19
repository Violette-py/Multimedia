function [a_quan]=ula_pcm(a,n,u)
%ULA_PCM 	u-law PCM encoding of a sequence
%       	[A_QUAN]=MULA_PCM(X,N,U).
%       	X=input sequence.
%       	n=number of quantization levels (even).     	
%		a_quan=quantized output before encoding.
%       U the parameter of the u-law

% todo: 

% ���æ��ɺ����������źŽ���ѹ��
compressed_signal = ulaw(a, u);

% ��ѹ���������źŽ��о�������
quantized_signal = u_pcm(compressed_signal, n);

% ���æ��ɺ����ķ������Ծ�����������źŽ������Ŵ���
a_quan = inv_ulaw(quantized_signal, u);

end