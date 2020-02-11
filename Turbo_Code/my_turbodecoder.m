clc,clear all,close all

Len_InterLeaver = 40;%长度按照3GPP188交织矩阵来安排
% CodeOri=round(rand(1,Len_InterLeaver));  %随机数，长度与交织长度相同
CodeOri = [1,1,0,1,1,0,0,1,1,1,0,1,1,0,1,0,0,1,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,0,0,1,1,0,1,1];
k=length(CodeOri);
x1 = zeros(1,k);%源码+尾码输出
z1 = zeros(1,k);%第一RSC+尾码输出
x2 = zeros(1,k);%源码交织输出
z2 = zeros(1,k);%第二RSC+尾码输出
%% 第一RSC编码+尾码终止准备

reg1=zeros(1,3); %初始化移位寄存器
for i=1:k
    a = mod((CodeOri(1,i)+reg1(1,2)+reg1(1,3)),2); %输入原码 与 反馈 计算得到下一个的更新值
    x1(1,i) = CodeOri(1,i);
    z1(1,i) = mod((a+reg1(1,1)+reg1(1,3)),2);
    reg1 = [a,reg1(1,[1:2])];%将下一个更新值输入到寄存器中
end
%trellis termination for RSC1 再多算三位(但用0更新寄存器！！)
x1 = [x1 0 0 0 0];
z1 = [z1 0 0 0 0];
for m=1:3
    x1(1,k+m) = mod((reg1(1,2)+reg1(1,3)),2);%网格终止阶段反馈路线改变了
    z1(1,k+m) = mod((reg1(1,1)+reg1(1,3)),2);
    reg1 = [0,reg1(1,[1:2])];      %尾比特用0更新寄存器（3GPP技术手册没有说，与图不符，不知正误？？，但也会改）
end
%% 伪随机交织

x2 = myinterleaf(CodeOri);%3GPP标准交织参数表
%% 第二RSC编码+尾码终止准备

reg2=zeros(1,3); %初始化移位寄存器
for j=1:k
    d = mod((x2(1,j)+reg2(1,2)+reg2(1,3)),2);
    z2(1,j) = mod((d+reg2(1,1)+reg2(1,3)),2);
    reg2 = [d,reg2(1,[1:2])];
end
%trellis termination for RSC2 再多算三位
x2 = [x2 0 0 0 0];
z2 = [z2 0 0 0 0];
for m=1:3
    x2(1,k+m) = mod((reg2(1,2)+reg2(1,3)),2);
    z2(1,k+m) = mod((reg2(1,1)+reg2(1,3)),2);
    reg2 = [0,reg2(1,[1:2])];
end
%% 网格终止开始 trellis termination

d0(1:k) = x1(1:k);%为什么是这样对应的关系也没找到？？
d1(1:k) = z1(1:k);
d2(1:k) = z2(1:k);
d3(1:k) = x2(1:k);

d0(1,k+1)=x1(1,k+1);d0(1,k+2)=z1(1,k+2);d0(1,k+3)=x2(1,k+1);d0(1,k+4)=z2(1,k+2);%参照标准
d1(1,k+1)=z1(1,k+1);d1(1,k+2)=x1(1,k+3);d1(1,k+3)=z2(1,k+1);d1(1,k+4)=x2(1,k+3);
d2(1,k+1)=x1(1,k+2);d2(1,k+2)=z1(1,k+3);d2(1,k+3)=x2(1,k+2);d2(1,k+4)=z2(1,k+3);
d3(1,k+1:k+4)=d0(1,k+1:k+4);%尾比特不交织

turbo_out(1,:)=d0;% 信息位
turbo_out(2,:)=d1;% 校验位
turbo_out(3,:)=d3;% 交织后信息位
turbo_out(4,:)=d2;% 交织后校验位
% turbo_out=2*turbo_out-ones(size(turbo_out));
% % 调制 将 1 调制成  +1
% %         0         -1