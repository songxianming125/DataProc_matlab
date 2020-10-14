function [varargout]=PFQuiver(varargin)
%%%********************************************************%%%
%%%       This program is to calculate                     %%%
%%%    the Magnetic field of PF coils and draw the quiver  %%%
%%%      Developed by Song xianming 2008/08/15/            %%%
%%%     modified by Song Xiao  on 2011/07/08/            %%%
%%%     modified by Song Xianming on 2011/09/15/            %%%
%%%     modified by Song Xianming on 2012/11/13/            %%%
%%%********************************************************%%%
% There are 2 CS coils and 16 PF coils, 18 in total           %

global ContentOfInterest
%current in PF coils
global Iex 
%field area
global X1 Y1

Iex=Iex*10000; %field in Gause need factor 1.0e4,will be restore later
%field area
%source area

DX=0;
DY=0;

pIex=Iex;
pX1=X1;
pY1=Y1;



if 1
    % parfor i=1:nargin
    for i=1:nargin
        index=abs(varargin{i});
        if pIex(index)~=0
            [X2,Y2,ATurnCoil]=getLocation(index);
            [DX1,DY1]=MMagneticField(pX1,pY1,X2,Y2,ATurnCoil);
            DX=DX+sign(varargin{i})*pIex(index).*DX1;  %why -
            DY=DY+sign(varargin{i})*pIex(index).*DY1;
        end
    end
else % use green function to calculate
    [row,col]=size(pX1);
    pX1=reshape(pX1,1,numel(pX1));
    pY1=reshape(pY1,1,numel(pY1));
    BPoint=[pX1;pY1];
    [BX,BY,BXp,BYp]=getBoundaryGreenFnBfield(BPoint,2); % 2=normal and tangential
    
    for i=1:nargin
        index=abs(varargin{i});
        iPF=sign(varargin{i})*pIex(index);
        if iPF~=0
            DX=DX+BX*reshape(Iex,numel(Iex),1);  %why -
            DY=DY+BY*reshape(Iex,numel(Iex),1);
        end
    end

    
    
    DX=reshape(DX,[row col]);
    DY=reshape(DY,[row col]);
    
    
end




Iex=Iex/10000; % gloabal Iex change to kA for restore. 

% if Ip~=0
%     [X4,Y4,I4]=GetPlasmaPara(Ip);%plasma as source
%     I4=I4*10000;% Tesla->Gauss
%     [DX1,DY1]=MMagneticField(X1,Y1,X4,Y4,I4);
%     DX=DX+DX1;
%     DY=DY+DY1;
% end



%%
v=[-30 -20 -10 -5 0 5 10];

switch  char(ContentOfInterest)
    case {'B'}
         quiver(X1,Y1,DX,DY,1);%,'-or'
%         quiver(X1,Y1,DX1,DY1,1);%,'-or'
%         DZ=sqrt(DX.^2+DY.^2);
%         [C,h] = contour(X1,Y1,DZ,10);
%         v=[5 10 15 20 30 40];
%         [C,h] = contour(X1,Y1,DZ,v);
%         [C,h] = contour(X1,Y1,DZ,20);
        
        %         clabel(C,h)
%         colorbar;
    case {'Bv'}
        DX=zeros(size(DX));
        quiver(X1,Y1,DX,DY,1);%,'-or'
        v=[-30 -15 -10 -5 0 5 10 15 30];
        [C,h] = contour(X1,Y1,DY,v);
        clabel(C,h)
        colorbar;
    case {'Br'}
        DY=zeros(size(DY));
        quiver(X1,Y1,DX,DY,1);%,'-or'
%         v=-[1 2 5 10 20 30 40 50];
        v=[-30 -20 -10 -5 -3 -2 -1 1 2 3 5 10 20 30];
        [C,h] = contour(X1,Y1,DX,v);
        clabel(C,h)
        colorbar;
   case {'AbsB'}
        set(gca,'FontSize',14,'FontWeight','bold')

        DZ=sqrt(DX.^2+DY.^2);
%         v=[30 100 500 2000 4000 4500 5000 5500 6000 8000 10000 12000];
        v=[5 10 20 30 50 100];
%         v=30.1;
%         [C,h] = contour(X1,Y1,DZ,10);
        [C,h] = contour(X1,Y1,DZ,v);
        htext=clabel(C,h,v);
        set(h,'LineWidth',1.5)
        set(htext,'FontSize',12,'FontWeight','bold')

%         colorbar;
end


%%
%automatically save the pic in jpg
%%

%DX=zeros(size(DX));
%DY=zeros(size(DY));

% del=max(DX(11,:))-min(DX(11,:));

% DZ=sqrt(DX.^2+DY.^2);
% %%
% %%
% 
% 
% %quiver(X1,Y1,DX,DY,1);%,'-or'
% [C,h] = contour(X1,Y1,DZ,10);
% clabel(C,h) 
%%
%output
if nargout==1
%     varargout{1}=mean(DX(:));
    varargout{1}=mean(DY(:));
elseif nargout==2
    varargout{1}=(DX);
    varargout{2}=(DY);
elseif nargout>2
    disp('too many output parameter for function')
end  
  
