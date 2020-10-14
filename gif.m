function gif(file,figure_handle,delaytime)
% gif('D:\test.gif',100,0.1)

    [I,map]=rgb2ind(frame2im(getframe(figure_handle)),256);

    if exist(file,'file')==2
        imwrite(I,map,file,'gif','DelayTime',delaytime,'WriteMode','append');
    else
        imwrite(I,map,file,'gif','DelayTime',delaytime,'Loopcount',Inf);
    end

end
