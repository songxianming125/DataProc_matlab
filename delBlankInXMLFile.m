function delBlankInXMLFile(xmlFileName)
  %% delete the blank
     fid = fopen(xmlFileName,'r','n','UTF-8');  % 'n' mean native machine format,,Order for reading bytes in the file
%     fid = fopen(xmlFileName,'r');  % 'n' mean native machine format,,Order for reading bytes in the file
%     MyString = fread(fid, '*char','n')';
    MyString = fread(fid, '*char','n')';
    fclose(fid);
% MyString1=MyString(1:end-2);    
    
    patternBlankReturn='\s{3,}';
%     patternBlankReturn='[\r\n\f\x{20}]{3,}';  % \x{20} is white-space
    replace='\n';
    MyString = regexprep(MyString,patternBlankReturn,replace);
    
    
    fid = fopen(xmlFileName,'w','n','UTF-8');
%     fid = fopen(xmlFileName,'w');
    fwrite(fid, MyString,'char','n');
    fclose(fid);
