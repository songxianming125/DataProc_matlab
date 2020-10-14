function fig2pic(varargin)
%e.g.   fig2pic(16,9,'pdf','D:\ECE\24996')
%
%	Copyright 2016-2017 YangZC@swip.ac.cn
%   Function depend on: Built-in function

Position=get(gcf,'Position');
Filename=get(gcf,'FileName');
Filename=Filename(1:end-4);
PaperUnits='centimeters';
%PaperUnits: points normlized centimeters inches

switch nargin
    case 0;w=Position(3);h=Position(4);exname='png'      ;PaperUnits='points';
    case 1;w=Position(3);h=Position(4);exname=varargin{1};PaperUnits='points';
    case 2;w=varargin{1};h=varargin{2};exname='png'      ;
    case 3;w=varargin{1};h=varargin{2};exname=varargin{3};
    case 4;w=varargin{1};h=varargin{2};exname=varargin{3};Filename=varargin{4};
end

switch exname
    case 'eps';form='epsc';
    case 'jpg';form='jpeg';
    case 'tif';form='tiff';
    otherwise ;form=exname;
end

if isempty(Filename)
    Filename=input('Input the [Path,Filename]\n');
end

set(gcf,'PaperUnits',PaperUnits,'PaperPosition',[0 0 w h],...
        'PaperType' ,'<custom>','PaperSize'    ,[w h])
print(gcf,['-d',form],'-r600',[Filename,'.',exname])
end