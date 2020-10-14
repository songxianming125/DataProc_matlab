Ga = gpuArray(rand(1000, 'single'));
% Ga = rand(1000, 'single');
Gfft = fft(Ga); 
Gb = (real(Gfft) + Ga) * 6;
G = gather(Gb);


return
t=[1 2 3 4];
y=sin(t);
block = signalbuilder([], 'create', t, y);


return


ncmFiles = unzip('http://sxm.swip.ac.cn/tempimg/songxm/my.zip');
return
[filestr,status] = urlwrite('http://sxm.swip.ac.cn/tempimg/songxm/my.zip','my.zip');
return
exPage = urlread(...
     'http://dp.swip.ac.cn');



return
load handel;
player = audioplayer(y, Fs);
play(player)
return

clc
clear

% Prepare the new file.
writerObj = VideoWriter('peaks','MPEG-4');
writerObj.FrameRate = 60;
open(writerObj);
axis equal

% Generate initial data and set axes and figure properties.
set(gca,'nextplot','replacechildren');
% set(gcf,'Renderer','zbuffer');
xlim([0 6.3])
ylim([-1 1])

% Setting the Renderer property to zbuffer or Painters works around limitations of getframe with the OpenGL renderer on some Windows systems.
% 
% Create a set of frames and write each frame to the file.
for k = 1:200 
    t=(0:1:k)*3.14/100;
    line(t,sin(t));
    frame =  getframe(gcf);
    writeVideo(writerObj,frame);
end


close(writerObj);


return












writerObj = VideoWriter('myV','MPEG-4');
open(writerObj);

% clear all
nFrames = 200;

% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
                        'colormap', []);

% Create movie.
% Z = peaks; surf(Z); 



% axis tight
figure
axis equal
xlim([0 3.14])
ylim([-1 1])

set(gca,'nextplot','replacechildren');
for k = 1:nFrames 
  t=0:0.01:3.14*k/200;

  line(t,sin(t));
   mov(k) = getframe(gcf);
end

% Create AVI file.
% movie2avi(mov, 'my.avi', 'compression', 'NONE', 'fps',5,'quality',1);
    writeVideo(writerObj,mov);

return






writerObj = VideoWriter('peaks.avi','MPEG-4');
open(writerObj);


Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');



for k = 1:20 
   surf(sin(2*pi*k/20)*Z,Z)
   frame = getframe;
   writeVideo(writerObj,frame);
end

close(writerObj);


return




% 
clc
clear
% nFrames = 20;
% 
% % Preallocate movie structure.
% mov(1:nFrames) = struct('cdata', [],...
%                         'colormap', []);
% 
% % Create movie.
% Z = peaks; surf(Z); 
% axis tight
% set(gca,'nextplot','replacechildren');
% for k = 1:nFrames 
%    surf(sin(2*pi*k/20)*Z,Z)
%    mov(k) = getframe(gcf);
% end
% 
% % Create AVI file.
% movie2avi(mov, 'myPeaks.avi', 'compression', 'None');
% return




return
Z = peaks;
figure('Renderer','zbuffer');
surf(Z);
axis tight;
set(gca,'NextPlot','replaceChildren');
for j = 1:20
    surf(sin(2*pi*j/20)*Z,Z)
    F(j) = getframe;
end
movie(F,20) % Play the movie twenty times
return




return
h5file='C:\DataProc\temp\d21589.h5';
list = h5read_z(h5file);

return
list = h5read_z(h5file);
filename='C:\DataProc\temp\d21559.h5';
ip = h5read(filename,'/ccG2');
return
filename='D:\sxm.h5';
info = h5info(filename);
return
list.id='sxm';
list.ccG2=ccG2;
list.ccZ2=ccZ2;
list.ccIv=ccIv;
list.ccV12=ccV12;
h5_dir='D:';
h5save_z(list,h5_dir);
return


filename='D:\sxm.h5';
h5disp(filename)

return
filename='D:\sxm.h5';
list = h5read_z(filename);
return
list.id='sxm';
list.ccG2=ccG2;
list.ccZ2=ccZ2;
list.ccIv=ccIv;
list.ccV12=ccV12;
h5_dir='D:';
h5save_z(list,h5_dir);
return

