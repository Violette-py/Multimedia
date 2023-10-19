function [a_quan]=u_pcm(a,n)
%U_PCM  	uniform PCM encoding of a sequence
%       	[A_QUAN]=U_PCM(A,N)
%       	a=input sequence.
%       	n=number of quantization levels (even).
%		a_quan=quantized output before encoding.

% todo: 

% 先为量化值序列分配与输入信号序列相同大小的内存空间（通过赋值操作进行）
a_quan = a;

% 获取量化范围（信号采样值区间）
a_max = max(a);
a_min = min(a);

% 设置量化间隔
d = (a_max - a_min) / n;

% 进行量化：将信号的采样值调整为量化值
for i = a_min: d: a_max
    % 创建逻辑索引数组，以选择每个量化区间中的所有采样点，并将该区间中的所有采样值量化成区间中点值
    a_quan(a_quan >= i & a_quan < (i+d)) = i + d/2;
end

end