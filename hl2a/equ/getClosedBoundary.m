function [X,Y]=getClosedBoundary(Xp,Yp,ap,elong,pointNum)
%%********************************************************
%       This program is to get the coordinates of 
%       a closed curve line as boundary                    
%      Developed by Song xianming 2008/08/15/            
%*******************************************************
%% 

angleStep=2*pi/pointNum;
theta=angleStep:angleStep:2*pi;

Y=Yp+elong.*ap.*sin(theta);
X=Xp+ap.*cos(theta);

