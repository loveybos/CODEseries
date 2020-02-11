function ConCode = conencodef(OrigiSeq,ConExpress)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 卷积编码器，只支持速率1/2编码
%%% OrigiSeq：输入待编码的原始序列，未添加冲洗尾比特
%%% ConExpress：输入上下路抽头系数矩阵，长度=寄存器个数
%%% ConCode：输出卷积码，长度为（输入加尾比特）*2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------调用-----------------------------------
% ConExpress = [1 1 1 1 0 1 0 1 1;1 0 1 1 1 0 0 0 1];
% ConCode = conencodef(OriCode,ConExpress);  
%-------------------------------------------------------
ConUp = ConExpress(1,:); %IS-95 (2,1,9)
ConDowm = ConExpress(2,:);

LengthCode = length(OrigiSeq);
LengthCon =  length(ConUp);
OrigiSeq = [OrigiSeq zeros(1,LengthCon)];%添加尾部冲洗码
Length = LengthCode + LengthCon;

ConCode1 = mod(conv(OrigiSeq,ConUp), 2);%上支路卷积编码输出
ConCode2 = mod(conv(OrigiSeq,ConDowm), 2);%下支路卷积编码输出

ConCode1 = ConCode1(1:Length);
ConCode2 = ConCode2(1:Length);
ConCode = zeros(1,2*Length);
    for j = 1 : Length
        ConCode(2*j-1) = ConCode1(j);
        ConCode(2*j) = ConCode2(j);
    end