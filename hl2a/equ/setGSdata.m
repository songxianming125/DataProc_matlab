function y=setGSdata
%% ********************************************************
%       This program is to calculate                    
%      the Green function of PF coils and Plasma
%      Developed by Song xianming 2014/2/17/            
%      parallel mode, please use matlabpool statement
%********************************************************
%% HL2A

coreNum=8;
if matlabpool('size')>0
    % already open
else
    %not open
    matlabpool(coreNum)
end


%% Plasma


    tic
    spmd
        Flux4Plasma=spmdPlasmaCoef(coreNum);
    end
    fluxPlasma=[];%initial
    for ii=1:coreNum
        fluxPlasma=[fluxPlasma; Flux4Plasma{ii}];
    end
    toc
    sourceLen=size(fluxPlasma,3);
    
    fluxPlasma=reshape(fluxPlasma,sourceLen,sourceLen);% this statement very slow
    save('c:\hl2a\data\equ\Flux4Plasma8_2A','fluxPlasma')
    tic
%% PF





spmd
     Flux4PF=spmdSetCoef(coreNum);
end
% 


fluxPF=[];%initial
for ii=1:coreNum
  fluxPF=[fluxPF; Flux4PF{ii}];
end
toc
sourceLen=size(fluxPF,1)*size(fluxPF,2);
fluxPF=reshape(fluxPF,sourceLen,size(fluxPF,3));%
save('c:\hl2a\data\equ\Flux4PF8_2A','fluxPF')
y=0;
% close
% if matlabpool('size')>0
%     % already open
%     matlabpool close
% else
%     %not open
% end
return



