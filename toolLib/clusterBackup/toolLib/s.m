%automatically save the pic in jpg
p='C:\jpg';

if ~exist(p)
    mkdir(p)
end

jpgfile=fullfile(p, 'tem.jpg');
[FileName,PathName,FilterIndex]=uiputfile('*.jpg','Save the jpg file!',jpgfile);
jpgfile=fullfile(PathName,FileName);
print(gcf,'-djpeg',jpgfile);
print(gcf,'-dmeta');  %in clipboard


