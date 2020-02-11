function ConCode = conencodef(OrigiSeq,ConExpress)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% �����������ֻ֧������1/2����
%%% OrigiSeq������������ԭʼ���У�δ��ӳ�ϴβ����
%%% ConExpress����������·��ͷϵ�����󣬳���=�Ĵ�������
%%% ConCode���������룬����Ϊ�������β���أ�*2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------����-----------------------------------
% ConExpress = [1 1 1 1 0 1 0 1 1;1 0 1 1 1 0 0 0 1];
% ConCode = conencodef(OriCode,ConExpress);  
%-------------------------------------------------------
ConUp = ConExpress(1,:); %IS-95 (2,1,9)
ConDowm = ConExpress(2,:);

LengthCode = length(OrigiSeq);
LengthCon =  length(ConUp);
OrigiSeq = [OrigiSeq zeros(1,LengthCon)];%���β����ϴ��
Length = LengthCode + LengthCon;

ConCode1 = mod(conv(OrigiSeq,ConUp), 2);%��֧·����������
ConCode2 = mod(conv(OrigiSeq,ConDowm), 2);%��֧·����������

ConCode1 = ConCode1(1:Length);
ConCode2 = ConCode2(1:Length);
ConCode = zeros(1,2*Length);
    for j = 1 : Length
        ConCode(2*j-1) = ConCode1(j);
        ConCode(2*j) = ConCode2(j);
    end