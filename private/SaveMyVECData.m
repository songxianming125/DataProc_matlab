function y=SaveMyVECData(MyFiles,myData);
[MyPath, MyFile, ext] = fileparts(MyFiles);
%if not the path then create it
if ~exist(MyPath,'dir')
    mkdir(MyPath)
end
%y=0 mean wrong, y=1 mean right
y=0;
try
    MyMode= 'a'; % 'a' mean :Open file, or create new file, for writing; append data to the end of the file.
    fid = fopen(MyFiles,MyMode);  %MyMode= 'w', or 'a'
        y=fwrite(fid,myData,'float32'); %对单精度浮点数
    status = fclose(fid);
y=1;
catch
y=0;
end