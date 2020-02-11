clc,clear all,close all

Len_InterLeaver = 40;%���Ȱ���3GPP188��֯����������
% CodeOri=round(rand(1,Len_InterLeaver));  %������������뽻֯������ͬ
CodeOri = [1,1,0,1,1,0,0,1,1,1,0,1,1,0,1,0,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,0,0,1,1,0,1,1];
k=length(CodeOri);
x1 = zeros(1,k);%Դ��+β�����
z1 = zeros(1,k);%��һRSC+β�����
x2 = zeros(1,k);%Դ�뽻֯���
z2 = zeros(1,k);%�ڶ�RSC+β�����
%% ��һRSC����+β����ֹ׼��

reg1=zeros(1,3); %��ʼ����λ�Ĵ���
for i=1:k
    a = mod((CodeOri(1,i)+reg1(1,2)+reg1(1,3)),2); %����ԭ�� �� ���� ����õ���һ���ĸ���ֵ
    x1(1,i) = CodeOri(1,i);
    z1(1,i) = mod((a+reg1(1,1)+reg1(1,3)),2);
    reg1 = [a,reg1(1,[1:2])];%����һ������ֵ���뵽�Ĵ�����
end
%trellis termination for RSC1 �ٶ�����λ(����0���¼Ĵ�������)
x1 = [x1 0 0 0 0];
z1 = [z1 0 0 0 0];
for m=1:3
    x1(1,k+m) = mod((reg1(1,2)+reg1(1,3)),2);%������ֹ�׶η���·�߸ı���
    z1(1,k+m) = mod((reg1(1,1)+reg1(1,3)),2);
    reg1 = [0,reg1(1,[1:2])];      %β������0���¼Ĵ�����3GPP�����ֲ�û��˵����ͼ��������֪���󣿣�����Ҳ��ģ�
end
%% α�����֯

x2 = myinterleaf(CodeOri);%3GPP��׼��֯������
%% �ڶ�RSC����+β����ֹ׼��

reg2=zeros(1,3); %��ʼ����λ�Ĵ���
for j=1:k
    d = mod((x2(1,j)+reg2(1,2)+reg2(1,3)),2);
    z2(1,j) = mod((d+reg2(1,1)+reg2(1,3)),2);
    reg2 = [d,reg2(1,[1:2])];
end
%trellis termination for RSC2 �ٶ�����λ
x2 = [x2 0 0 0 0];
z2 = [z2 0 0 0 0];
for m=1:3
    x2(1,k+m) = mod((reg2(1,2)+reg2(1,3)),2);
    z2(1,k+m) = mod((reg2(1,1)+reg2(1,3)),2);
    reg2 = [0,reg2(1,[1:2])];
end
%% ������ֹ��ʼ trellis termination

d0(1:k) = x1(1:k);%Ϊʲô��������Ӧ�Ĺ�ϵҲû�ҵ�����
d1(1:k) = z1(1:k);
d2(1:k) = z2(1:k);
d3(1:k) = x2(1:k);

d0(1,k+1)=x1(1,k+1);d0(1,k+2)=z1(1,k+2);d0(1,k+3)=x2(1,k+1);d0(1,k+4)=z2(1,k+2);%���ձ�׼
d1(1,k+1)=z1(1,k+1);d1(1,k+2)=x1(1,k+3);d1(1,k+3)=z2(1,k+1);d1(1,k+4)=x2(1,k+3);
d2(1,k+1)=x1(1,k+2);d2(1,k+2)=z1(1,k+3);d2(1,k+3)=x2(1,k+2);d2(1,k+4)=z2(1,k+3);
d3(1,k+1:k+4)=d0(1,k+1:k+4);%β���ز���֯

turbo_out(1,:)=d0;% ��Ϣλ
turbo_out(2,:)=d1;% У��λ
turbo_out(3,:)=d3;% ��֯����Ϣλ
turbo_out(4,:)=d2;% ��֯��У��λ
% turbo_out=2*turbo_out-ones(size(turbo_out));
% % ���� �� 1 ���Ƴ�  +1
% %         0         -1