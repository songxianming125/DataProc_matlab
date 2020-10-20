% make_mdsipmex.m
% make sure ../mdsplus points to current version of mdsplus distribution
% to make the debug version, debug=1;make_mdsipmex;
% to make the shared version, shared=1;make_mdsipmex;
% Note; if shared, install MdsIpShr library or point $LD_LIBRARY_PATH to shareables
% Basil P. DUVAL, May 2000

MDSPLUS=getenv('MDSPLUS');
if(length(MDSPLUS)==0)
  disp('shell variable MDSPLUS must point to MDSPLUS distribution before compilation');end

if(exist('debug','var'));DEBUG = '-DDEBUG';else;DEBUG='';end

if(~strcmp(computer,'VMS'));PASSWD = '-DPASSWD';else;PASSWD='mdsipmex.opt';end

if (strcmp(computer,'PCWIN64'))
  M='C:\\Program Files\\MDSplus'
  comm = sprintf('mex "%s\\matlab\\mdsipmex.c" -I"%s\\DEVTOOLS\\include" -L"%s\\bin_x86_64" -lMdsIpShr -lMdsShr wsock32.lib',M,M,M)
else
if(~exist('shared','var'))
%r={'mdsipshr.c','mdsiputil.c','vmshpwd.c','adler32.c','compress.c','deflate.c','infblock.c','infcodes.c',...
r={'mdsipshr.c','mdsiputil.c','adler32.c','compress.c','deflate.c','infblock.c','infcodes.c',...
            'inffast.c','inflate.c','inftrees.c','infutil.c','trees.c','uncompr.c','zutil.o','mdsip_socket_io.c'};
comm = sprintf('mex %s %s mdsipmex.c -I%s/include -I%s/mdstcpip',DEBUG,PASSWD,MDSPLUS,MDSPLUS);
for(i=1:length(r))
     comm = sprintf('%s %s/mdstcpip/%s',comm,MDSPLUS,char(r(i)));end
else
comm = sprintf('mex %s %s mdsipmex.c -I%s/include -I%s/mdstcpip -L%s/lib -lMdsIpShr',...
	       DEBUG,PASSWD,MDSPLUS,MDSPLUS,MDSPLUS);
end
end
disp(comm);eval(comm);
