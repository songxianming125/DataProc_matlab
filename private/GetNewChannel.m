function [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex]=ParseChannelName(CurrentChannels)
i=strfind(CurrentChannels,'(');
j=strfind(CurrentChannels,':');
k=strfind(CurrentChannels,'%');
L=size(CurrentChannels,2);
MyIndex=1;
IndexStart=1;
IndexEnd=1;
CurrentChannel=CurrentChannels;
NickName=CurrentChannels;
%there are four case
if i 
    CurrentChannel=CurrentChannels(1:i-1);
    NickName=CurrentChannel;
    if j
        IndexStart=str2num(CurrentChannels(i+1:j-1));
        IndexEnd=str2num(CurrentChannels(j+1:L-1));    
    else
        MyIndex=str2num(CurrentChannels(i+1:L-1));
        IndexStart=MyIndex;
        IndexEnd=MyIndex;  
    end
else    
    if j
        CurrentChannel=CurrentChannels(1:j-1);
        NickName=CurrentChannels(j+1:L);
        if k
            MyIndex=str2num(CurrentChannels(k+1:j-1));
            IndexStart=MyIndex;
            IndexEnd=MyIndex;    
        end
    else
        if k
            MyIndex=str2num(CurrentChannels(k+1:L));
            IndexStart=MyIndex;
            IndexEnd=MyIndex;    
        end
    end
end

