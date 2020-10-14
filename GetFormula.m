function [Expression,Dependence]=GetFormula(CurrentChannel)
%get the formula from the file Formula.txt by the channel name
Expression=[];
Dependence=[];
MyPath= which('DP');
FormulaFile=[MyPath(1:end-4) 'configurations' filesep 'Formula.txt'];


fid = fopen(FormulaFile,'r');
remain = fread(fid, '*char')';
status = fclose('all');



if ispc
    mytok =[char(13) char(10)];
elseif isunix
    mytok =[char(10)];
end


k = strfind(remain, mytok);
for i=1:length(k)/3+1
    [mychannelname, remain] = strtok(remain, mytok);
    if strmatch(mychannelname, CurrentChannel, 'exact')
        [Expression, remain] = strtok(remain, mytok);
        [Dependence, remain] = strtok(remain, mytok);
        return
    end
    [myexpression, remain] = strtok(remain, mytok);
    [mydependence, remain] = strtok(remain, mytok);
end
return
k = strfind(remain, char(13));
for i=1:length(k)/3+1
    [mychannelname, remain] = strtok(remain, [char(13) char(10)]);
    if strmatch(mychannelname, CurrentChannel, 'exact')
        [Expression, remain] = strtok(remain, [char(13) char(10)]);
        [Dependence, remain] = strtok(remain, [char(13) char(10)]);
        return
    end
    [myexpression, remain] = strtok(remain, [char(13) char(10)]);
    [mydependence, remain] = strtok(remain, [char(13) char(10)]);
end
