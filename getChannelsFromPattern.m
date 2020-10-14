function chnlList = getChannelsFromPattern( channelPattern)
global MyChanLists handles
machine=getappdata(0,'machine');


switch machine
    case {'exl50','east'}
        cmd=['FileName=''' machine '.mat'';'];
        eval(cmd)
        %         FileName='exl50.mat';
        %     case 'east'
        %         FileName='east.mat';
        
        cfgFile=fullfile(getDProot(machine),FileName);
        load(cfgFile);
        chnlList=myChnlString;
        
        
        pattern=['(?<=;)\w*',channelPattern, '\w*(?=;)'];
        cmd=['chnlList =regexpi(chnlList,pattern,''match'');'];
        eval(cmd)
    case {'hl2a', 'localdas','hl2m'}
        
        
        
        %% prepare the namelist
        if isempty(MyChanLists)
            sShots=get(handles.ShotNumber,'String');
            if iscell(sShots)
                CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
            else
                CurrentShot=str2num(sShots);
            end
            y=setSystemName(CurrentShot,1);
        end
        
        
        %% find the possible match channel
        
        % change .* to \w* for Any alphabetic, numeric, or underscore character
        namePattern=regexprep(channelPattern,'\.','\\w');
        
        %     channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*(?=\x3A)'];
        %  \xD=13   \xA=10  \x3A=':'  \x5C='\'
        channelPattern=['(?<=\xD\xA)[^\x3A]*' namePattern '[^\x3A]*(?=\x3A[a-zA-Z]{3}\xD\xA)'];
        ChanLists=regexpi(MyChanLists,channelPattern,'match');
        ChanLists=regexprep(ChanLists,'\x3A','\x5C');
        
        
        %%
        
        %add the curves from GetCurveByFormula
        CurveNames=GetCurveNames;
        patternname=['.\w*',namePattern, '.*'];
        %     sNames=cellfun(@regexpi,CurveNames,patternname,'match','once');
        
        sNames = regexpi(CurveNames, patternname, 'match','once');
        index=~cellfun(@isempty,sNames);
        Names=sNames(index);
        chnlList=[ChanLists'; Names];
end


end

