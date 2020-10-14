%% Calculate Inductance or mutual Inductance
%  Developed by Song xianming 2008/08/15/           
% 1 indicates field, 2 indicates source 
% the index1 for coils
% modified in 2016/09/21

%% for 2M
% plasma 1
% CSU+CSL   2
% PF1   3 4 (U L)
% PF2   5 6 (U L)
% PF3   7 8 (U L)
% PF4   9 10 (U L)
% PF5   11 12  (U L)
% PF6   13 14  (U L)
% PF7   15 16  (U L)
% PF8   17 18  (U L)

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
function L=getML2A(index1,index2)
%field
[X1,Y1,fieldTurnCoil,gapX1]=getLocation(index1);
% source
[X2,Y2,sourceTurnCoil,gapX2]=getLocation(index2);
gapX=min(gapX1(1),gapX2(1));
L=dot(fieldTurnCoil,MMutInductance(X1,Y1,X2,Y2,sourceTurnCoil,gapX));
L=L*1e3; %H-->mH
return


%%  comment
        % more comments about inductances connect in series       %
        % two Inductances with L1, L2 and M, connect in series
        % L=(L1+L2+2*M)

        
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
        
 %%       

