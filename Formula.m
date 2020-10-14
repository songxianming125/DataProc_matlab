function [vecY,VecT,varargout]=Formula(CurrentShot,Expression,varargin)
%[vecY,vecT,strSys,strUnit]=Formula(iCurrentShot,strCurrentChannel,strExpression,
%iTend/strInfFilePath,iInterpPeriod/strFrequency,strCurrentSysName,strInfFilePath);
%
% input
% option  VarName             DataType           Meaning
% 1      iCurrentShot:       int                shot number
% 1      strCurrentChannel:  char/cell array     channel name(s)
% 1      strExpression:     char/cell array     expression(s)
% 0      strDpendence:     char/cell array      dependence(s)
% 0      iTstart/strSys:     int/char         starting time/system
% 0      iTend:              int/double         ending time
% 0      iInterpPeriod:      int/double         interpolation time
% 0      strFrequency:     char              frequency in Hz
% 0      strCurrentSysName:  char        system name which the channel belongs to 
% 0      strInfFilePath:     char        path for the information file other than HL-2A database, such as your local file
% option=1 means the item is necessary, option=0 means the item is optional
% output:
% option    VarName             DataType        Meaning      
% 1         VecY                double array    output y
% 1         VecT                double array    output t
% 0         strSys              char            system name
% 0         strUnit             char            unit name
Dependence=[];
vecY=[];
VecT=[];
if nargin>=3
    if ~isempty(varargin{1}) && ischar(varargin{1}) %
        Dependence=varargin{1};
    end
end

%string conditioning
Expression=strrep(Expression,'"','');
Expression=lower(Expression);
Expression=strrep(Expression,'[','');
Expression=strrep(Expression,']','');
Expression=regexprep(Expression,'(?<!\.)([/*///^])','.$1');

Expression=lower(Expression);

%for the variable which has a dependence, prepare and assign a value

if ~isempty(Dependence)
    Dependence=lower(Dependence);
    remain=Dependence;
    k = strfind(remain, ';');
    for i=1:length(k)+1
        [mydependence, remain] = strtok(remain, ';');
        [mysystem, mychannel] = strtok(mydependence, ':');
        while length(mychannel)>5 && mychannel(5)==':';
            mychannel(1)=[];
            [mysystem, mychannel] = strtok(mychannel, ':');
        end

        if ~isempty(mychannel)
            mypattern='(?<=[\,\:])\w*(?=\,)|(?<=[\,\:])\w*$';
            curchannels=regexp(mychannel, mypattern, 'match');
            if isempty(curchannels)
                continue
            end
            % assign value to curchannels
            curchannels=unique(curchannels);  %
            if strmatch(mysystem,'ccs','exact')
                for j=1:length(curchannels)

                    mycommand=['[y,t]=hl2adb(' num2str(CurrentShot) ',curchannels{',num2str(j),'},mysystem);'];
%                    another way to get data 
%                     mycommand=['[y,t]=hl2adb(' num2str(CurrentShot) ',''' curchannels{i1} ''',''' mysystem ''');'];
                    eval(mycommand)
                    if isempty(t)
                        msgbox(['the channel (' curchannels{j} ') is not found'])
                        return
                    end
                    %------------------------------------------------------------
                    if isempty(VecT)
                        VecT=t;
                    end
                        myvar=curchannels{j};
                        
                        mypattern=['^(' myvar ')(?=\W)|(?<=\W)(' myvar ')(?=\W)|(?<=\W)(' myvar ')$'];
                        Expression=regexprep(Expression ,mypattern,['y' myvar]); %name conditioning
                        mycommand=['y' myvar '=y;']; %add y to var name
                        eval(mycommand)
                        mycommand=['t' myvar '=t;']; %add t to var name
                        eval(mycommand)

                end
            else
                mycommand=['[y,t]=hl2adb(' num2str(CurrentShot) ',curchannels,mysystem);'];
                eval(mycommand)
                if isempty(t)
                    msgbox(['the channel (' curchannels{1} ') is not found'])
                    return
                end
                %------------------------------------------------------------
                if isempty(VecT)
                    VecT=t;
                end

                for j=1:length(curchannels)
                    myvar=curchannels{j};
                    mypattern=['^(' myvar ')(?=\W)|(?<=\W)(' myvar ')(?=\W)|(?<=\W)(' myvar ')$'];
                    Expression=regexprep(Expression ,mypattern,['y' myvar]); %name conditioning
                    mycommand=['y' myvar '=y(:,j);']; %add y to var name
                    eval(mycommand)
                    mycommand=['t' myvar '=t;'];
                    eval(mycommand)
                end
            end
            
            
        end
    end
end



%for calculating the manually editted channels

mybuiltins=[{'sin'} {'cos'} {'log'} {'abs'} {'ABS'}];
% mypattern='^[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+$';
%there are three kinds, 1=begin + (non ope) + op; 2=op + (non op) +op; 
%3=op +(non op) +end
mypattern='^[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+$';
myvarname=regexp(Expression, mypattern, 'match');%|\.[\*\/\^]
myvarname=unique(myvarname); 



%for the variable which has no dependence
for i=1:length(myvarname)
    myvar=myvarname{i};
%     isbuiltin = strmatch(myvar, mybuiltins, 'exact');
    isbuiltin = exist(myvar,'builtin');
    if isempty(isbuiltin) || ~isbuiltin
%         [x status] = str2num(myvar);
          x= str2double(myvar);
        if isnan(x)
            isvar = exist(myvar,'var');
            if ~isvar
%                 myvar1=strrep(myvar,'@','');  %??
%                 myvar=curchannels{j};
%                 Expression=strrep(Expression ,myvar,['y' myvar]); %name conditioning
%                 mycommand=['[y' myvar1 ',t]=hl2adb(' num2str(CurrentShot) ',' char(39) myvar char(39) ');'];
%                 
                myChannel=myvar;  %channel and var is quite different
                myvar=strrep(myvar,'@','');  %??
                mypattern=['^(' myvar ')(?=\W)|(?<=\W)(' myvar ')(?=\W)|(?<=\W)(' myvar ')$'];
                Expression=regexprep(Expression ,mypattern,['y' myvar]); %name conditioning
                
                mycommand=['[y' myvar ',t]=hl2adb(' num2str(CurrentShot) ',' char(39) myChannel char(39) ');'];
                
                eval(mycommand)
                if isempty(t)
                    msgbox(['the channel (' myvar ') is not found'])
                    return
                end
                if isempty(VecT)
                    VecT=t;
                end
                mycommand=['t' myvar '=t;'];%name conditioning
                eval(mycommand)
            else
                mycommand=['t=t' myvar(2:end) ';'];  %restore t 
                eval(mycommand)
            end
% %------------------------------------------------------------
%            %signal time conditionning
            VecT=TimeTailor(VecT,t);
        end

%         if ~status
%         end
    end
end


%reconditionning the variable name

mybuiltins=[{'sin'} {'cos'} {'log'} {'abs'} {'ABS'}];
% mypattern='^[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+$';
%there are three kinds, 1=begin + (non ope) + op; 2=op + (non op) +op; 
%3=op +(non op) +end
mypattern='^[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+(?=[\.\+\-\*\/\^\(\)])|(?<=[\+\-\*\/\^\(\)])[^\.\+\-\*\/\^\(\)]+$';
myvarname=regexp(Expression, mypattern, 'match');%|\.[\*\/\^]
myvarname=unique(myvarname); 


% ------------------------------------------------------------
%%            %signal  conditionning
for i=1:length(myvarname)
    bconditionning=0;
    myvar=myvarname{i};
    myvar=strrep(myvar,'@','');
    isvar = exist(myvar,'var');
    if isvar
        mycommand=['t=t' myvar(2:end) ';'];
        eval(mycommand)
        if length(VecT)~=length(t)
            bconditionning=1;
        else
            if VecT(1)==t(1) && VecT(end)==t(end)
            else
               bconditionning=1; 
            end
        end

        %signal  conditionning
        if bconditionning==1
            mycommand=['y=' myvar ';'];
            eval(mycommand)
            index=interp1(t,[1:length(t)],VecT,'nearest','extrap');
            y=y(index);
            mycommand=[myvar '=y;'];
            eval(mycommand)
        end
    end
end

%calculate the expression
Expression=strrep(Expression,'@','');%name conditioning
myexpression=['vecY=' Expression ';'];
eval(myexpression);
