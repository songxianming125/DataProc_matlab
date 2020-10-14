function setOptionParameter(str,value)
    optionsFileName=fullfile(getDProot,'options.xml');
    
    xDoc=xmlread(optionsFileName);
    xRoot=xDoc.getDocumentElement();
    xString=xRoot.getElementsByTagName(str);
    %    shotnum=char(xShot.item(0).getTextContent());
    xString.item(0).setTextContent(value)
    xmlwrite(optionsFileName,xDoc)
    
   %% open again and delete the white-space
    delBlankInXMLFile(optionsFileName)
    %% delete the blank
%     fid = fopen(optionsFileName,'r','n','UTF-8');
%     MyString = fread(fid, '*char','n')';
%     fclose(fid);
%     %    patternBlankReturn='\s{3,}';
%     patternBlankReturn='[\r\n\f\x{20}]{3,}';
%     replace='\n';
%     MyString = regexprep(MyString,patternBlankReturn,replace);
%     fid = fopen(optionsFileName,'w','n','UTF-8');
%     fwrite(fid, MyString,'char','n');
%     fclose(fid);
% 
