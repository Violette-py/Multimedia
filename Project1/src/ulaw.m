function [z]=ulaw(y,u)
%		u-law nonlinearity for nonuniform PCM
%		X=ULAW(Y,U).
%		Y=input vector.

% todo: 

% ���ɺ�����ѹ������
% ���ݦ��ɺ����Ķ��壬����������ķ�Χͨ����[-1,1]֮�䣬������Ҫ��y���й�һ������
y_max = max(abs(y));
z = (sign(y) .* log(1 + u * abs((y / y_max)))) ./ log(1 + u);

end