function [a_quan]=u_pcm(a,n)
%U_PCM  	uniform PCM encoding of a sequence
%       	[A_QUAN]=U_PCM(A,N)
%       	a=input sequence.
%       	n=number of quantization levels (even).
%		a_quan=quantized output before encoding.

% todo: 

% ��������ź����й�һ����[-1,1]��������
a_quan = a ./ max(abs(a));

% �����������Ϊ2/n
d = 2 / n;

% ���źŵĳ���ֵ����Ϊ��Ӧ������ֵ
for i = -1: d: 1
    a_quan(a_quan >= i & a_quan < (i + d)) = (2 * i + d) / 2;
end

end
