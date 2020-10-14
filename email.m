function s=email(varargin)
toAddress=[]; % many should be cell
Title=[];
Line1=[];
attachedFiles=[]; % many should be cell
% order of information
if nargin>=4
    toAddress=varargin{1};
    Title=varargin{2};
    Line1=varargin{3};
    attachedFiles=varargin{4};
elseif nargin>=3
    toAddress=varargin{1};
    Title=varargin{2};
    Line1=varargin{3};
elseif nargin>=2
    toAddress=varargin{1};
    Title=varargin{2};
elseif nargin>=1
    toAddress=varargin{1};
end
s=1;
fromAddress = 'songxm@swip.ac.cn'; %your email address
if isempty(toAddress)
    toAddress = {'wangs@swip.ac.cn','songxm@swip.ac.cn','songx@swip.ac.cn','lib@swip.ac.cn'};
end
setpref('Internet','E_mail',fromAddress);
setpref('Internet','SMTP_Server','smtp.swip.ac.cn');
setpref('Internet','SMTP_Username',fromAddress);
[user, psw]=getPSW;
setpref('Internet','SMTP_Password',psw); %your password

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
if isempty(Title)
    Title='send by matlab';
end
if isempty(Line1)
    Line1='Test for email function';
end
if isempty(attachedFiles)
%     attachedFiles={'c:\hl2a\email.m','c:\hl2a\runaway.m','C:\DataProc\getPSW.m'};
    attachedFiles=[];
end

Line2='Sincerly Yours';
Line3='Xianming SONG';
Line4='songxm@swip.ac.cn';
sendmail(toAddress, Title,...
        [Line1 10 Line2 10 ...
         Line3 10 Line4],attachedFiles);
disp('email sending is ok!')
s=0;

% props.setProperty('mail.smtp.socketFactory.class', ...
%                   'javax.net.ssl.SSLSocketFactory');
% props.setProperty('mail.smtp.socketFactory.port','465');
% 
% sendmail(myaddress, 'Gmail Test', 'This is a test message.');