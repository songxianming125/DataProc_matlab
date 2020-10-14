function [X1,Y1,ATurnCoil,varargout]=getLocation(index)
%% ********************************************************
% This program is to Set Location of PF coils of HL2A      
%      Developed by Song xianming 2013/12/18/            
%******    ************
%% ********************************************************
% 2A :
% the index for coils
% OH   1
% VF   2
% RF   3
% MP1U  4
% MP2U  5
% MP3U  6
% MCU  7
% MP1L  8
% MP2L  9
% MP3L  10
% MCL  11

factor=0.23;
NX=4;
NY=4;
ATurnCoil=[];
X1=[];  
Y1=[];
gapX=[];





switch index
    case 1 %OH
        % upper part
        NumCoil=12;
        XCenter(1:NumCoil)=[0.905 0.905 0.905 0.905 0.905 0.905 0.9745 1.087 1.208 1.725 2.049 2.475];
        YCenter(1:NumCoil)=[0.1 0.286 0.472 0.658 0.844 1.030 1.236 1.359 1.411 1.398 1.172 0.3888];
        W(1:NumCoil)=[0.058 0.058 0.058 0.058 0.058 0.058 0.062 0.062 0.062 0.066 0.066 0.066];
        H(1:NumCoil)=[0.145 0.145 0.145 0.145 0.145 0.145 0.158 0.135 0.112 0.059 0.059 0.036];
        N(1:NumCoil)=[5 5 5 5 5 5 6 5 4 2 2 1];  %线圈匝数
    case 2 %VF
        % upper part
        NumCoil=8;
        XCenter(1:NumCoil)=[1.008 1.008 1.008 1.008 1.987 2.345 2.438 2.46];
        YCenter(1:NumCoil)=[0.055 0.34 0.45 0.56 1.21 0.776 0.563 0.325];
        W(1:NumCoil)=[0.028 0.028 0.028 0.028 0.028 0.028 0.028 0.079];
        H(1:NumCoil)=[0.079 0.079 0.079 0.079 0.079 0.079 0.079 0.028];
        N(1:NumCoil)=[1 1 1 1 -1 -1 -1 -1];  %线圈匝数
    case 3 %RF
        % upper part plus lower part 
        NumCoil=4;
        XCenter(1:NumCoil)=[1.006 2.38 1.006 2.38];
        YCenter(1:NumCoil)=[0.8 0.537 -0.8 -0.537];
        W(1:NumCoil)=[0.026 0.020 0.026 0.020];
        H(1:NumCoil)=[0.056 0.026 0.056 0.026];
        N(1:NumCoil)=[2 1 -2 -1];  %线圈匝数
    case 4 %MP1U
        X=1.355;
        Y=0.498;
        % transfer circle to square
        
        R=0.065*0.45; % 0.065 is the radius; 0.45 is the gap
        XV=[-R -R R R];
        YV=[-R R R -R];

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=Y+YV;
        W(1:NumCoil)=[1 1 1 1]*R*2;
        H(1:NumCoil)=[1 1 1 1]*R*2;
        N(1:NumCoil)=-[1 1 1 1];  %线圈匝数
     case 5 %MP2U
        X=1.5165;
        Y=0.6753;
        R=0.0875*0.45; % 45%
        XV=[-R -R R R];
        YV=[-R R R -R];
        WH=[1 1 1 1]*R*2;

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=Y+YV;
        W(1:NumCoil)=WH;
        H(1:NumCoil)=WH;
        N(1:NumCoil)=[2 2 2 2];  %线圈匝数
    case 6 %MP3U
        
        X=1.727;
        Y=0.56;
        % transfer circle to square
        
        R=0.065*0.45; % 0.065 is the radius; 0.45 is the gap
        XV=[-R -R R R];
        YV=[-R R R -R];

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=Y+YV;
        W(1:NumCoil)=[1 1 1 1]*R*2;
        H(1:NumCoil)=[1 1 1 1]*R*2;
        N(1:NumCoil)=-[1 1 1 1];  %线圈匝数
      case 7 %MCU
        NumCoil=4;
        XCenter(1:NumCoil)=[1.008 1.825 2.284 2.3841];
        YCenter(1:NumCoil)=[0.165 1.312 0.745 0.371];
        W(1:NumCoil)=[0.028 0.028 0.028 0.079];
        H(1:NumCoil)=[0.079 0.079 0.079 0.028];
        N(1:NumCoil)=[-1 1 1 -1];  %线圈匝数
    case 8 %MP1L
        X=1.355;
        Y=0.498;
        % transfer circle to square
        
        R=0.065*0.45; % 0.065 is the radius; 0.45 is the gap
        XV=[-R -R R R];
        YV=[-R R R -R];

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=-(Y+YV);
        W(1:NumCoil)=[1 1 1 1]*R*2;
        H(1:NumCoil)=[1 1 1 1]*R*2;
        N(1:NumCoil)=-[1 1 1 1];  %线圈匝数
     case 9 %MP2L
        X=1.5165;
        Y=0.6753;
        R=0.0875*0.45; % 45%
        XV=[-R -R R R];
        YV=[-R R R -R];
        WH=[1 1 1 1]*R*2;

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=-(Y+YV);
        W(1:NumCoil)=WH;
        H(1:NumCoil)=WH;
        N(1:NumCoil)=[2 2 2 2];  %线圈匝数
    case 10 %MP3L
        X=1.727;
        Y=0.56;
        % transfer circle to square
        
        R=0.065*0.45; % 0.065 is the radius; 0.45 is the gap
        XV=[-R -R R R];
        YV=[-R R R -R];

        % transfer circle to square
        NumCoil=4;
        XCenter(1:NumCoil)=X+XV;
        YCenter(1:NumCoil)=-(Y+YV);
        W(1:NumCoil)=[1 1 1 1]*R*2;
        H(1:NumCoil)=[1 1 1 1]*R*2;
        N(1:NumCoil)=-[1 1 1 1];  %线圈匝数
     case 11 %MCL
        NumCoil=4;
        XCenter(1:NumCoil)=[1.008 1.825 2.284 2.3841];
        YCenter(1:NumCoil)=-[0.165 1.312 0.745 0.371];
        W(1:NumCoil)=[0.028 0.028 0.028 0.079];
        H(1:NumCoil)=[0.079 0.079 0.079 0.028];
        N(1:NumCoil)=[-1 1 1 -1];  %线圈匝数
     otherwise
        warning('no such coils');
end


%% prepare the output
for indexL=1:NumCoil
    ATurnCoil=[ATurnCoil linspace(1,1,NX*NY)*N(indexL)/(NX*NY)]; %ampere turn
    StepX=W(indexL)/NX/2;
    StepY=H(indexL)/NY/2;
    %source
    
    [X2,Y2]=meshgrid(-W(indexL)/2+StepX:2*StepX:W(indexL)/2-StepX,...
        -H(indexL)/2+StepY:2*StepY:H(indexL)/2-StepY);
    %no tilting adjustment
    
    
    X2=X2+XCenter(indexL);
    Y2=Y2+YCenter(indexL);
    %reshape source
    X2=reshape(X2,1,numel(X2));
    Y2=reshape(Y2,1,numel(X2));
    
    X1=[X1 X2];
    Y1=[Y1 Y2];
    gapX=[gapX linspace(1,1,NX*NY)*2*StepX*factor];
end

%%
switch index
    case {1,2} % OH VF
        % UPPER PLUS LOWER
        ATurnCoil=[ATurnCoil ATurnCoil]; %ampere turn
        X1=[X1 X1];
        Y1=[Y1 -Y1];
        gapX=[gapX gapX];
    otherwise
end

if nargout==4
    varargout{1}=gapX;
end
return

