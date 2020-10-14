function s=SaveInHDF5(hObject,eventdata,handles)
% Developed by Dr. X.M.Song. songxm@swip.ac.cn
% 
global   MyCurves h5file
s=0;
%%
%prepare file name for saving


MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end


if isempty(h5file)
    MyPath= which('DP');
    h5file=fullfile(MyPath(1:end-4),'temp',['d' MyShot '.h5']);
    [FileName,PathName,~]=uiputfile('*.h5','Input your file name',h5file);
    h5file=fullfile(PathName,FileName);
else
    
    filePattern='(?<=\w)\d{4,5}(?=[\x2E]h5)';
    h5file=regexprep(h5file,filePattern,MyShot);
    
    
end


%%
%prepare data and save
n=length(MyCurves);


if n>0
    for i=1:n
        %prepare variable name
        myName=MyCurves(i).ChnlName;
        myName = regexprep(myName, '[\x40]',''); %name conditionning
        myName = regexprep(myName, '\W','_'); %name conditionning
        
        %prepare variable value
        MyVar=MyCurves(i).x;
        MyVar(:,2)=MyCurves(i).y;
        myCommand=['data.' myName '=MyVar;'];
        eval(myCommand);
    end
end

h5save_z(data,h5file) %Programmed by J. Zhang: xyzhangj@physics.ucla.edu

s=1;
return
%%-------------------------------------------------------------------------------

