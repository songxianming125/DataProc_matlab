function [info,picture,t]=downloadcine(shotnum,t1,t2,camera)
% This function is based on cine format of Phantom camera,
% cinefilename is the direction of cine file.
% varagin is the optional input parameter, Usually it should be {start_frame,end_frame},
% start and end time, if you just want the first frame to the end frame,just ignore it.
% flag is used to specifies wether you want to download frames (falg=1) or
% you just want  to get the information of current shot (flage=0);
% Edited by GuoDong 2020-03-27

% CAUTION   there are two cameras around EXL50
dt=1;
switch nargin
    case 1
        t1=0;t2=Inf; camera='M120';
    case 2
        t2=Inf; camera='M120';
    case 3
        camera='M120';
    case 4
        if camera=='1'
            camera='M120';
        else
            camera='D240';
        end
end
%-------cine format------------------
%%
shotnum_name=[camera,'-',num2str(shotnum),'.cine'];
cd(['\\diskstation\exl50-camera\',camera]);
temp=dir('**/*.cine');
index = find(strcmp({temp.name}, shotnum_name)==1);
cinefilename=[temp(index,:).folder,'\',camera,'-',num2str(shotnum),'.cine'];
if isempty(index)
    msg=['There is No such a shotnum in database：',num2str(shotnum)];
    error(msg)
end

fid=fopen(cinefilename,'r');
cinefileheader={'Type','HeaderSize','Compression','Version','FirstMovieImage','TotalImageCount','FirstImageNo','ImageCount','OffImageHeader','OffSetup','OffImageOffsets'};
cinefileheader_pointer={'0000','0002','0004','0006','0008','000C','0010','0014','0018','001C','0020'};
cinefileheader_type={'uint16','uint16','uint16','uint16','int32','uint32','int32','uint32','uint32','uint32','uint32'};

bitmapinfoheader={'biSize','biWidth','biHeight','biPlanes','biBitCount','biCompression','biSizeImage','biXPelsPerMeter','c'};
bitmapinfoheader_pointer={'002C','0030','0034','0038','003A','003C','0040','0044','0048'};
bitmapinfoheader_type={'uint32','int32','int32','uint16','uint16','uint32','uint32','int32','int32'};

setup_name={'Length','FrameRate ','ImWidth','ImHeight','BlackLevel','WhiteLevel','LensAperture','LensFocusDistance','RealBPP','exposure'};
setup_pointer={'00E2','0354','0335','0337','16B8','16BC','17C0','17C4','03D4','0358'};
setup_type={'uint16','uint32','uint8','int32','uint32','uint16','uint16','int32','int32','uint32'};

for i=1:length(cinefileheader)
    fseek(fid, hex2dec(cinefileheader_pointer(i)), 'bof');
    temp1{i}=fread(fid, 1, cinefileheader_type{i});
end

for i=1:length(bitmapinfoheader)
    fseek(fid, hex2dec(bitmapinfoheader_pointer(i)), 'bof');
    temp2{i}=fread(fid, 1, bitmapinfoheader_type{i});
end

for i=1:length(setup_name)
    fseek(fid, hex2dec(setup_pointer(i)), 'bof');
    temp3{i}=fread(fid, 1, setup_type{i});
end
%%
info.FirstMovieImage=temp1{5};
info.TotalMovieImage=temp1{6};
info.FirstImage=temp1{7};
info.TotalImage=temp1{8};
info.EndImage=temp1{8}+temp1{7}-1;
info.Width=temp2{2};
info.Height=temp2{3};
info.biCompression=temp2{6};
info.biSizeImage=temp2{7};
info.biXPelsPerMeter=temp2{8};
info.biYPelsPerMeter=temp2{9};
info.FrameRate=temp3{2};
info.LensAperture=temp3{7};
info.LensFocusDistance=temp3{8};
info.RealBPP=temp3{9};
info.exposure=temp3{10};
imagecount=info.TotalImage;
%%
fs=info.FrameRate;
frm_min=floor((t1+dt)*fs);
frm_max=ceil((t2+dt)*fs);
if frm_max>info.EndImage
%     msgbox(['The EndImage is ',num2str(info.EndImage),' T2 should be corrected to < ',num2str(info.EndImage/300)]);
    frm_max=info.EndImage;
end    
%%
fseek(fid,hex2dec(setup_pointer{1}),'bof');
aux=fread(fid,1,'short');  %The length of setup infomation, To read the blocks we should pass these
pos1=temp1{end-1};
pos2=temp1{end};

pos=floor((pos1+aux+8)/512);
fseek(fid,pos*512,'bof');
n=mod(pos1+aux+8,512);
if (n ~= 0)
    a=fread(fid,n,'ubit8');
    times=fread(fid,[2,imagecount],'ulong');
else
    times=fread(fid,[2*imagecount],'ulong');
end

fseek(fid,hex2dec('0024'),'bof');
ttrig=fread(fid,2,'uint32');
times=(times(1,:)/(2^32)-ttrig(1)/(2^32))+(times(2,:)-ttrig(2));

%%
fseek(fid,temp1{end},'bof');
pimage=fread(fid,info.TotalImage,'uint64'); % 所有images的指针地址，从该地址中获取想要读取的图像；

switch info.RealBPP
    case 10
        bitFormat = '*ubit10';
    otherwise
        bitFormat = 'uint16';
end
    k=1;
    picture=zeros(frm_max-frm_min+1,info.Height,info.Width);
    if frm_min<=0
    frm_min=1;
    end
    if frm_max>info.TotalImage
       frm_max=info.EndImage;
    end
    for frame=frm_min:frm_max

        fseek(fid,pimage(frame),'bof');
        aux=fread(fid,1,'ulong');    
        fseek(fid,pimage(frame)+aux,'bof');
          switch info.RealBPP
            case 10
                a=fread(fid,[info.Width,info.Height], bitFormat,'ieee-be');
            otherwise
                a=fread(fid,[info.Width,info.Height], bitFormat);
          end        
         temp=rot90(a);
        if shotnum<5009
        picture(k,:,:)=flipud(temp);  
        else
        picture(k,:,:)=temp;      
        end
        k=k+1;
        text=['Frame:',num2str(frame)]
    end
    t=times(frm_min:frm_max);
    fclose(fid);

end