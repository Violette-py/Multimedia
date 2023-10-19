function [z]=ulaw(y,u)
%		u-law nonlinearity for nonuniform PCM
%		X=ULAW(Y,U).
%		Y=input vector.

% todo: 

% μ律函数（压缩器）
% 根据μ律函数的定义，其输入变量的范围通常在[-1,1]之间，所以需要对y进行归一化处理
y_max = max(abs(y));
z = (sign(y) .* log(1 + u * abs((y / y_max)))) ./ log(1 + u);

end