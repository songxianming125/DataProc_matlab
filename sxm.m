function [varargout]=sxm(varargin)
%% encryption(0) or decryption(1)
if nargin>0
    action=varargin{1};
else
    action=1;
end






switch action
    case 0 %encryption default
        PasswordFile=fullfile('D:\', 'sxm.txt');
        
        fid = fopen(PasswordFile,'r');
        code = fread(fid, '*char')';
        status = fclose(fid);
        myString=encrRSA(code,143,23);
        
        
        PasswordFile=fullfile('D:\', 'sxmEncr.txt');
        
        fid = fopen(PasswordFile,'w');
        fwrite(fid,myString, 'char');
        status = fclose(fid);
        varargout{1}='decrypt the code successfully!';
    case 1 % decryption default
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');
        fid = fopen(PasswordFile,'r');
        encrString= fread(fid, '*char')';
        status = fclose(fid);
        
        defUser='input code below';
        defPsw='';
        [~,code]=logindlg(defUser,defPsw);
        
        myString=encrRSA(code,143,23);
        TF=strcmp(myString,encrString);
        
        
        if TF
            PasswordFile=fullfile('D:\', 'sxmEncr.txt');
            fid = fopen(PasswordFile,'r');
            code = fread(fid, '*char')';
            status = fclose(fid);
            
            myString=decrRSA(code,143,47);
            PasswordFile=fullfile('D:\', 'sxm.txt');
            fid = fopen(PasswordFile,'w');
            fwrite(fid,myString, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
            
        end
        
        
    case -2% encryption your file by uigetfile
        % get the encrypted password
        MyPath= which('DP');
        %         PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.txt');
        fid = fopen(PasswordFile,'r');
        encrString= fread(fid, '*char')';
        status = fclose(fid);
        v=double(encrString);
        
        channelPattern=['[\d]*'];
        SystemName=regexpi(encrString,channelPattern,'match');
        
        PasswordFile=[PasswordFile '29'];
        fid = fopen(PasswordFile,'w');
        % %        fwrite(fid,[char(13) char(10)], 'char');
        %        for i=1:length(SystemName)
        %            fwrite(fid,encrRSA(SystemName{i},143,23), 'char');
        %            fwrite(fid,[char(13) char(10)], 'char');
        %        end
        
        
        fwrite(fid,encrRSA(encrString,68021,5473), 'char');
        
        
        status = fclose(fid);
        
        %         channelPattern=['^[\S]*(?=\xD\xA)'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        %
        %         channelPattern=['(?<=\xD\xA)[\S]*(?=\xD\xA)'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        %
        %         channelPattern=['(?<=\xD\xA)[\S]*$'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        
        
        defUser='input code below';
        defPsw='';
        [~,code]=logindlg(defUser,defPsw);
        
        myString=encrRSA(code,68021,5473);
        TF=strcmp(myString,encrString);
        
        
        
        
        
        
        
        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '/']);
            PasswordFile=fullfile(PathName, FileName);
            fid = fopen(PasswordFile,'r');
            code = fread(fid, '*char')';
            status = fclose(fid);
            
            myString=decrRSA(code,143,47);
            
            
            PasswordFile=[PasswordFile '29'];
            fid = fopen(PasswordFile,'w');
            fwrite(fid,myString, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
            
        end
    case -3
        
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.txt');
        PasswordFile=[PasswordFile '29'];
        
        
        
        
        %         PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');
        %         PasswordFile=fullfile(MyPath(1:end-4), 'psw.txt');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        encrString=decrRSA(code,68021,37);
        v=double(encrString);
        
        channelPattern=['[\d]*'];
        SystemName=regexpi(encrString,channelPattern,'match');
        
        PasswordFile=[PasswordFile '29'];
        fid = fopen(PasswordFile,'w');
        fwrite(fid,encrRSA('\xD\xA',143,23), 'char');
        for i=1:length(SystemName)
            fwrite(fid,encrRSA([SystemName{i} '\xD\xA'],143,23), 'char');
        end
        status = fclose(fid);
        
        %         channelPattern=['^[\S]*(?=\xD\xA)'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        %
        %         channelPattern=['(?<=\xD\xA)[\S]*(?=\xD\xA)'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        %
        %         channelPattern=['(?<=\xD\xA)[\S]*$'];
        %         SystemName=regexpi(encrString,channelPattern,'match');
        
        
        defUser='input code below';
        defPsw='';
        [~,code]=logindlg(defUser,defPsw);
        
        myString=encrRSA(code,143,23);
        TF=strcmp(myString,encrString);
        
        
        
        
        
        
        
        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '/']);
            PasswordFile=fullfile(PathName, FileName);
            fid = fopen(PasswordFile,'r');
            code = fread(fid, '*char')';
            status = fclose(fid);
            
            myString=decrRSA(code,143,47);
            
            
            PasswordFile=[PasswordFile '29'];
            fid = fopen(PasswordFile,'w');
            fwrite(fid,myString, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
            
        end
    case 10%  build your password file. plaintext password
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
            n=str2double(SystemName{3});
            e=str2double(SystemName{4});
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
            %             n=str2double(SystemName{6});
            %             e=str2double(SystemName{7});
            n=str2double(SystemName{3});
            e=str2double(SystemName{4});
        end
        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '/']);
            PasswordFile=fullfile(PathName, FileName);
            fid = fopen(PasswordFile,'r');
            myString= fread(fid, '*char')';
            status = fclose(fid);
            code=decrRSA(myString,n,e);
            
            %build a new psw file
            PasswordFile=PasswordFile(1:end-2);
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
    case 11% build your password file, cipher code
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
            n=str2double(SystemName{3});
            e=str2double(SystemName{5});
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
            %             n=str2double(SystemName{6});
            %             e=str2double(SystemName{8});
            n=str2double(SystemName{3});
            e=str2double(SystemName{5});
        end
        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '/']);
            PasswordFile=fullfile(PathName, FileName);
            
            fid = fopen(PasswordFile,'r');
            myString= fread(fid, '*char')';
            status = fclose(fid);
            code=encrRSA(myString,n,e);
            
            %build a new psw file
            PasswordFile=[PasswordFile '37'];
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
    case 20%  build your password file. plaintext password
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='43112609';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        end
        
        n=341;
        e=7;       
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '\HL32.BMP43']);
            PasswordFile=fullfile(PathName, FileName);
            fid = fopen(PasswordFile,'r');
            myUint16= fread(fid, '*uint16')';
            status = fclose(fid);
            code=decrRSAuint(myUint16,n,e);
            
%             
%             [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '\HL32.BMP']);
%             PasswordFile=fullfile(PathName, FileName);
%             
%             fid = fopen(PasswordFile,'r');
%             myInteger= fread(fid, '*uint8')';
%             status = fclose(fid);
%             
%   
%             offset=code-double(myInteger);
%             total=sum(offset(:));
            
            
            %build a new psw file
            PasswordFile=PasswordFile(1:end-2);
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'uint8');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
        
    case 21% build your password file, cipher code  uint8->char
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='43112609';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        end
        
        n=341;
        e=43;        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '\HL32.BMP']);
            PasswordFile=fullfile(PathName, FileName);
            
            fid = fopen(PasswordFile,'r');
            myInteger= fread(fid, '*uint8')';
            status = fclose(fid);
            
            
            code=encrRSAuint(myInteger,n,e);
            
%             code=decrRSAuint(code,n,7);
%             offset=code-double(myInteger);
%             total=sum(offset(:));

            
            
            
            %build a new psw file
            PasswordFile=[PasswordFile '43'];
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'uint16');
            status = fclose(fid);
            
            
%             
%             fid = fopen(PasswordFile,'r');
%             myInteger= fread(fid, '*uint8')';
%             status = fclose(fid);
%             
            
            
            
            
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
    case 31% build your password file, cipher code
        % get the encrypted password
        MyPath= which('DP');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
            n=str2double(SystemName{3});
            e=str2double(SystemName{5});
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
            %             n=str2double(SystemName{6});
            %             e=str2double(SystemName{8});
            n=str2double(SystemName{3});
            e=str2double(SystemName{5});
        end
        
        
        if TF
            [FileName,PathName]=uigetfile('*.*','Load the data file',[MyPath(1:end-4) '/']);
            PasswordFile=fullfile(PathName, FileName);
            
            fid = fopen(PasswordFile,'r');
            myString= fread(fid, '*char')';
            status = fclose(fid);
            code=encrRSA(myString,n,e);
            
            %build a new psw file
            PasswordFile=[PasswordFile '37'];
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
    case 100%  build your password file. plaintext password
        % get the encrypted password
        MyPath= which('DP');
        %         PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        end
        
        
        if TF
            PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
            fid = fopen(PasswordFile,'r');
            myString= fread(fid, '*char')';
            status = fclose(fid);
            code=decrRSA(myString,str2double(SystemName{3}),str2double(SystemName{5}));
            
            %build a new psw file
            PasswordFile=fullfile(MyPath(1:end-4), 'sxm.utf8');
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
        
    case 101% build your password file, cipher code
        % get the encrypted password
        MyPath= which('DP');
        %         PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');
        PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
        fid = fopen(PasswordFile,'r');
        code= fread(fid, '*char')';
        status = fclose(fid);
        
        
        decrString=decrRSA(code,68021,37);
        channelPattern=['[\d]*'];
        SystemName=regexpi(decrString,channelPattern,'match');
        
        defUser='input code below';
        defPsw='';
        [~,psw]=logindlg(defUser,defPsw);
        myString=encrRSA(psw,str2double(SystemName{3}),str2double(SystemName{5}));
        
        
        TF = strcmp(encrRSA(SystemName{1},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        if TF
        else
            TF = strcmp(encrRSA(SystemName{2},str2double(SystemName{3}),str2double(SystemName{5})), myString);
        end
        
        
        if TF
            PasswordFile=fullfile(MyPath(1:end-4), 'sxm.utf8');
            
            fid = fopen(PasswordFile,'r');
            myString= fread(fid, '*char')';
            status = fclose(fid);
            code=encrRSA(myString,str2double(SystemName{3}),str2double(SystemName{5}));
            
            %build a new psw file
            PasswordFile=fullfile(MyPath(1:end-4), 'psw.utf8');
            fid = fopen(PasswordFile,'w');
            fwrite(fid,code, 'char');
            status = fclose(fid);
            varargout{1}='encrypt the code successfully!';
            
        else
            msgbox('you are forbidden to decrypt the code!')
            varargout{1}='unsuccessful encryption';
        end
end


