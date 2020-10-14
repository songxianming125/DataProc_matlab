%% Calculate Inductance or mutual Inductance
%  Developed by Song xianming 2008/08/15/           
% 1 indicates field, 2 indicates source 
% the index1 for coils

%% for 2M
% plasma 0
% PF1   1
% PF2   2
% PF3   3
% PF4   4
% PF5   5
% PF6   6
% PF7   7
% PF8   8
% PF9   9
% PF10   10
% PF11   11
% PF12   12
% PF13   13
% PF14   14
% PF15  15
% PF16  16

% CS in series 's'
% CS in parallel 'p'

%% for 2A

% plasma 0
% OH   1
% VF   2
% RF   3
% MP1U 4
% MP2U 5
% MP3U 6
% MCU 7
% MP1L 8
% MP2L 9
% MP3L 10 
% MCL 11


%%
function L=getML(index1,index2)

%field
if ischar(index1)
    if strcmpi(index1,'p')% CSU and CSL connect in parallel
        index=index2;%
        index2='p';
        [X2,Y2,fieldTurnCoil]=getLocation(index);
        %field
        X1=X2;  %
        Y1=Y2;
    end
    if strcmpi(index1,'s')% CSU and CSL connect in series
        % more comments about inductances connect in series       %
        % two Inductances with L1, L2 and M, connect in series
        % L=(L1+L2+2*M)

        index=1;%CSU
        [X2,Y2,fieldTurnCoil]=getLocation(index);
        %field
        X1=X2;  %
        Y1=Y2;
        
        index=2;%CSL
        [X2,Y2,fieldTurnCoil2]=getLocation(index);
        %field
        X1=[X1 X2];  %
        Y1=[Y1 Y2];
        fieldTurnCoil=[fieldTurnCoil fieldTurnCoil2];
    end
elseif isnumeric(index1)
    if index1>0
        index=index1;%
        [X2,Y2,fieldTurnCoil]=getLocation(index);
        %field
        X1=X2;  %
        Y1=Y2;
    elseif index1==0
        [X1,Y1,fieldTurnCoil]=GetPlasmaPara;
    end
else
    disp('input parameter is wrong!')
end


%source
if ischar(index2)
    if strcmpi(index2,'p')% CSU and CSL connect in parallel
        
        %more comments about inductances connect in parallel       %
        % two Inductances with L1, L2 and M, connect in parallel
        % L=(L1*L2-M*M)/(L1+L2-2*M)
        % if L1=L2 the L=(L1+M)/2
        
        %M*I=L*(i1+i2)
        %i1=(M1*L2-M*M2)/((L1*L2-M*M))
        %i2=(M2*L1-M*M1)/((L1*L2-M*M))
        %L=(L1*L2-M*M)/(L1+L2-2*M);
        %MI=(M1*L2-M*M2+M2*L1-M*M1)/(L1+L2-2*M)
        
        
        
        
        
        %more comments about mutual inductance (MI) between one coil  and two coils connecting in parallel       %
        % the two coils connecting in parallel have the same inductance L
        % and mutual inductance M.  
        % the mutual inductance between the one coil and the two coils are
        % M1 and M2 respectively.
        % The MI=((L+M)/2)*((M1+M2)*(L-M)/(L*L-M*M))=((M1+M2)/2)
        
        
        %calculate the M1
        
        index=1;%
        [X2,Y2,sourceTurnCoil,gapX]=getLocation(index);
        %flux for field point
        M1=dot(fieldTurnCoil,MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX));
        % Inductance
        
        
        index=2;%
        [X2,Y2,sourceTurnCoil,gapX]=getLocation(index);
        M2=dot(fieldTurnCoil,MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX));
        % Inductance
        
        %more comments about inductances connect in parallel       %
        % two Inductances with L1, L2 and M, connect in parallel
        % L=(L1*L2-M*M)/(L1+L2-2*M)
        % if L1=L2 the L=(L1+M)/2
        
        %more comments about mutual inductance (MI) between one coil  and two coils connecting in parallel       %
        % the two coils connecting in parallel have the same inductance L
        % and mutual inductance M.  
        % the mutual inductance between the one coil and the two coils are
        % M1 and M2 respectively.
        % The MI=((L+M)/2)*((M1+M2)*(L-M)/(L*L-M*M))=(M1+M2)/2
%         L=getML(1,1); %recursive call  inductance of CSU
%         M=getML(1,2); %recursive call  mutual inductance
%         
%          L=0.00117;
%         MI=((L+M)/2)*((M1+M2)*(L-M)/(L*L-M*M));
%         L=MI;

%when L1!=L2
        
        
        %M*I=L*(i1+i2)
        %i1=(M1*L2-M*M2)/((L1*L2-M*M))
        %i2=(M2*L1-M*M1)/((L1*L2-M*M))
        %L=(L1*L2-M*M)/(L1+L2-2*M);
        %M=(M1*L2-M*M2+M2*L1-M*M1)/(L1+L2-2*M)
        L1=getML(1,1); %recursive call  inductance of CSi
        M=getML(1,2); %recursive call  mutual inductance
        L2=getML(2,2); %recursive call  inductance of CSo
        MI=(M1*L2-M*M2+M2*L1-M*M1)/(L1+L2-2*M);
%         MI=M1;%when L1=M
        L=MI;
    end
    if strcmpi(index2,'s')% CSU and CSL connect in parallel
        %more comments about mutual inductance (MI) between one coil  and two coils connecting in series       
        % the two coils connecting in series have the inductance L1 and L2, and
        % mutual inductance M. the two coil system has 
        %L=L1+L2+2*M. %for the two coil system
        
        % the mutual inductance between the one coil and the two coils are
        % M1 and M2 respectively.
        
        %MI=M1+M2  %(o+o   ->O)
        
        index=1;%CSU
        [X2,Y2,sourceTurnCoil,gapX]=getLocation(index);
        
        index=2;%CSL
        [X4,Y4,sourceTurnCoil4,gapX4]=getLocation(index);
        
        X2=[X2 X4];  %
        Y2=[Y2 Y4];
        sourceTurnCoil=[sourceTurnCoil sourceTurnCoil4];
        gapX=[gapX gapX4];
        
        MM=fieldTurnCoil.*MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX);
        % Inductance
        L=sum(MM(:));
    end
elseif isnumeric(index2)
    if index2>0
        index=index2;%
        [X2,Y2,sourceTurnCoil,gapX]=getLocation(index);
        %flux for field point
        MM=fieldTurnCoil.*MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX);
        % Inductance
        L=sum(MM(:));
    elseif index2==0
        [X2,Y2,sourceTurnCoil]=GetPlasmaPara;
        gapX=0.23*abs(X2(2)-X2(1));
        %flux for field point
        L=dot(fieldTurnCoil,MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX));
%         MM=fieldTurnCoil.*MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX);
%         % Inductance
%         L=sum(MM(:));
    end
else
    disp('input parameter is wrong!')
end
L=L*1e3; %H-->mH
return






