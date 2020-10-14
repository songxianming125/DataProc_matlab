function [XCenter,YCenter,W,H,NX,NY,N,R,L,S,Imax,C, Labels]=GetPFParameter
%%%********************************************************%%%
%%% This program is to Set the parameter of PF coils       %%%
%%%                                                        %%%
%%%      Developed by Song xianming 2008/08/19/            %%%
%%%     modified by Song Xiao  on 2011/07/08/            %%%
%%%     checked and modified by Song Xianming on 2011/09/15/ %%%
%%%******    modified again in 2012/11/07    ************%%%
%%%********************************************************%%%
%the index for coils
% OH0   1 2
% PF1   3 4 (ui di)
% PF2   5 6(ue de)
% PF3   7 8
% PF4   9 10
% PF5   11 12 
% PF6   13 14 
% PF7   15 16 
% PF8   17 18 


%row extension


%OH from LiuJian, PF from Zhangjh
%OH from LI Jiaxian 2012/11/07
XCenter=[748 748 912 912 912 912 912 912 912 912 1092 1092 1501 1501 2500 2500 2760 2760]/1000; %m 11/09/15
YCenter=[860.575 -860.575 194 -194 582 -582 970 -970 1358 -1358 1753 -1753 1790 -1790 1200 -1200 480 -480]/1000;%m
W=[116.75 116.75 50 50 50 50 50 50 50 50 183 183 257 257 195 195 183 183]/1000;%m
H=[1721.15 1721.15 358 358 358 358 358 358 358 358 220 220 146 146 220 220 220 220]/1000;%m

NX=[2 2 2 2 2 2 2 2 2 2 5 5 7 7 5 5 5 5]*4;
NY=[24 24 14 14 14 14 14 14 14 14 6 6 4 4 6 6 6 6]*4;
% NX=[2 2 2 2 2 2 2 2 2 2 5 5 7 7 5 5 5 5];
% NY=[24 24 14 14 14 14 14 14 14 14 6 6 4 4 6 6 6 6];
N=[48 48 28 28 28 28 28 28 28 28 28 28 28 28 26 26 26 26]; %real turn of coils, not the product


R=[11.4 7.3 7.3 0.13 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%mOhmic
L=[19.1 9.9 9.9 0.02 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%mH

S=[22*55 30*48 30*48 60*60 60*60 0 0 0 0 0 0 0 0 0 0 0 0 0]/1000000;%m2, cross-section
Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 40 40 40 40 40 40 40 40]*1e3;%kA
C={'r','r','m','m','b','b','k','k','g','g','c','c','y','y','k','k','b','b'};
Labels={'OH' 'OH' 'PF1' 'PF1' 'PF2' 'PF2' 'PF3' 'PF3' 'PF4' 'PF4' 'PF5' 'PF5' 'PF6' 'PF6' 'PF7' 'PF7' 'PF8' 'PF8'};


