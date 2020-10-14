function [y,x,NewChannel]=LoadNewCurve4Add(CurrentChannels)


i=strfind(CurrentChannels,'/');
j=strfind(CurrentChannels,':');
L=size(CurrentChannels,2);
CurrentIndex=0;
%there are 4 status


if i 
    CurrentChannel=CurrentChannels(1:i-1);
    if j
         CurrentIndex=str2num(CurrentChannels(i+1:j-1));
         NewChannel=CurrentChannels(j+1:L);
     else
         NewChannel=CurrentChannel;
         CurrentIndex=str2num(CurrentChannels(i+1:L));
     end
     load(CurrentChannel);
     x=MyData(:,2*CurrentIndex-1);
     y=MyData(:,2*CurrentIndex);
else
    if j
        CurrentChannel=CurrentChannels(1:j-1);
        NewChannel=CurrentChannels(j+1:L);
    else
        CurrentChannel=CurrentChannels;
        NewChannel=CurrentChannel;
    end
     load(CurrentChannel);
     x=MyData(:,1);
     y=MyData(:,2);
end
