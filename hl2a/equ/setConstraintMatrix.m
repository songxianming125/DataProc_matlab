function constraintMatrix=setConstraintMatrix(constraintMatrix,varargin)
%% set the constraint coeficient



constraintMatrix(2,1)=-1;  
constraintMatrix(2,2)=1;

%PF1-4 is part of CS


if nargin>1
    %ramp up , plasma shape control
    switch varargin{1}
        case 1
            

% Z=1.4    3.4969e-07
% [-37499.7542603225,-37499.7542517311,-6818.13720592610,-6818.13720592610,-4999.96721009967,-4999.96721009967,-2499.98355850196,-2499.98355850196,7499.95086951309,7499.95086951308,16342.4928091635,16342.4928091635,8848.64686209310,8848.64686209310,-34064.5895145191,-34064.5895145190,-16185.6409292575,-16185.6409292575];
%             constraintMatrix(3,1)=-1/5.5;
%             constraintMatrix(4,1)=-1/5.5;
%             constraintMatrix(5,1)=-1/7.5;
%             constraintMatrix(6,1)=-1/7.5;
%             constraintMatrix(7,1)=-1/15;
%             constraintMatrix(8,1)=-1/15;
%             constraintMatrix(9,1)=1/5;
%             constraintMatrix(10,1)=1/5;
            
            
% Z=1.4    4.3924e-07
% [-36338.2191496171,-36338.2191418579,-6606.94902569421,-6606.94902569421,-5191.17413915158,-5191.17413915158,-3028.18485689875,-3028.18485689875,1816.91097962259,1816.91097962259,26027.6599090683,26027.6599090683,5420.03333600528,5420.03333600528,-33747.2134438812,-33747.2134438812,-16328.1969704727,-16328.1969704727];            
%             constraintMatrix(3,1)=-1/5.5;
%             constraintMatrix(4,1)=-1/5.5;
%             constraintMatrix(5,1)=-1/7;
%             constraintMatrix(6,1)=-1/7;
%             constraintMatrix(7,1)=-1/12;
%             constraintMatrix(8,1)=-1/12;
%             constraintMatrix(9,1)=1/20;
%             constraintMatrix(10,1)=1/20;
% Z=1.4   4.2113e-07
%[-34939.4003019621,-34939.4002939287,-6987.88014539824,-6987.88014539824,-5823.23335825413,-5823.23335825414,-2911.61662231631,-2911.61662231631,1746.97003628594,1746.97003628594,24953.2109958926,24953.2109958926,5725.25573687981,5725.25573687981,-33774.7925867232,-33774.7925867232,-16309.9383392053,-16309.9383392053];            
            
%             constraintMatrix(3,1)=-1/5;
%             constraintMatrix(4,1)=-1/5;
%             constraintMatrix(5,1)=-1/6;
%             constraintMatrix(6,1)=-1/6;
%             constraintMatrix(7,1)=-1/12;
%             constraintMatrix(8,1)=-1/12;
%             constraintMatrix(9,1)=1/20;
%             constraintMatrix(10,1)=1/20;
% Z=1.4  4.5634e-07
%[-34520.0208443818,-34520.0208369549,-6904.00426299862,-6904.00426299861,-5753.33678189449,-5753.33678189449,-3835.55779700552,-3835.55779700552,1726.00106503819,1726.00106503819,25589.8995115739,25589.8995115739,5577.92839048471,5577.92839048471,-33753.4918117315,-33753.4918117315,-16335.0293118526,-16335.0293118526];
            
%             constraintMatrix(3,1)=-1/5;
%             constraintMatrix(4,1)=-1/5;
%             constraintMatrix(5,1)=-1/6;
%             constraintMatrix(6,1)=-1/6;
%             constraintMatrix(7,1)=-1/9;
%             constraintMatrix(8,1)=-1/9;
%             constraintMatrix(9,1)=1/20;
%             constraintMatrix(10,1)=1/20;
            
% % Z=1.4  3.7825e-07
% %[-32153.7050812257,-32153.7050727350,-8038.42634463575,-8038.42634463574,-6430.74099140038,-6430.74099140038,-3572.63383465067,-3572.63383465067,3215.37052718849,3215.37052718849,20663.2357999800,20663.2357999800,7177.37989691891,7177.37989691891,-33917.3683360795,-33917.3683360795,-16245.8538113455,-16245.8538113455];
%             
%             constraintMatrix(3,1)=-1/4;
%             constraintMatrix(4,1)=-1/4;
%             constraintMatrix(5,1)=-1/5;
%             constraintMatrix(6,1)=-1/5;
%             constraintMatrix(7,1)=-1/9;
%             constraintMatrix(8,1)=-1/9;
%             constraintMatrix(9,1)=1/10;
%             constraintMatrix(10,1)=1/10;
            
% Z=1.4  3.2452e-07
%[-32589.1599780533,-32589.1599695261,-8147.29005665704,-8147.29005665705,-6517.83197104344,-6517.83197104344,-3621.01772069492,-3621.01772069492,8147.29001041849,8147.29001041849,12376.6068603216,12376.6068603216,10144.8155474863,10144.8155474863,-34183.8319284068,-34183.8319284068,-16136.3351412151,-16136.3351412151];
            
%             constraintMatrix(3,1)=-1/4;
%             constraintMatrix(4,1)=-1/4;
%             constraintMatrix(5,1)=-1/5;
%             constraintMatrix(6,1)=-1/5;
%             constraintMatrix(7,1)=-1/9;
%             constraintMatrix(8,1)=-1/9;
%             constraintMatrix(9,1)=1/4;
%             constraintMatrix(10,1)=1/4;
            
% Z=1.4  3.5189e-07            
%             constraintMatrix(3,1)=-1/5;
%             constraintMatrix(4,1)=-1/5;
%             constraintMatrix(5,1)=-1/7;
%             constraintMatrix(6,1)=-1/7;
%             constraintMatrix(7,1)=-1/10;
%             constraintMatrix(8,1)=-1/10;
%             constraintMatrix(9,1)=1/4;
%             constraintMatrix(10,1)=1/4;
%             
% % 2.4088e-07            
%             constraintMatrix(3,1)=-1/5;
%             constraintMatrix(4,1)=-1/5;
%             constraintMatrix(5,1)=-1/7;
%             constraintMatrix(6,1)=-1/7;
%             constraintMatrix(7,1)=-1/12;
%             constraintMatrix(8,1)=-1/12;
%             constraintMatrix(9,1)=1/10;
%             constraintMatrix(10,1)=1/10;
            
%             constraintMatrix(3,1)=-1/8;
%             constraintMatrix(4,1)=-1/8;
%             constraintMatrix(5,1)=-1/12;
%             constraintMatrix(6,1)=-1/12;
%             constraintMatrix(7,1)=-1/20;
%             constraintMatrix(8,1)=-1/20;
%             constraintMatrix(9,1)=1/10;
%             constraintMatrix(10,1)=1/10;
    end
else % field null configuration 
    % z=1.1 test
    constraintMatrix(3,1)=-1/8.9;
    constraintMatrix(4,1)=-1/8.9;
    constraintMatrix(5,1)=-1/8.4;
    constraintMatrix(6,1)=-1/8.4;
    constraintMatrix(7,1)=-1/8.0;
    constraintMatrix(8,1)=-1/8.0;
    constraintMatrix(9,1)=-1/7.8;
    constraintMatrix(10,1)=-1/7.8;
    % z=1.1 very good double null 3MA t=3.0s
%     constraintMatrix(3,1)=-1/9.8;
%     constraintMatrix(4,1)=-1/9.8;
%     constraintMatrix(5,1)=-1/9.0;
%     constraintMatrix(6,1)=-1/9.0;
%     constraintMatrix(7,1)=-1/8.4;
%     constraintMatrix(8,1)=-1/8.4;
%     constraintMatrix(9,1)=-1/7.8;
%     constraintMatrix(10,1)=-1/7.8;
%     
    
%     % z=1.1  0.0119 phi=9.4587
%     constraintMatrix(3,1)=-1/9.9;
%     constraintMatrix(4,1)=-1/9.9;
%     constraintMatrix(5,1)=-1/9.3;
%     constraintMatrix(6,1)=-1/9.3;
%     constraintMatrix(7,1)=-1/8.8;
%     constraintMatrix(8,1)=-1/8.8;
%     constraintMatrix(9,1)=-1/7.8;
%     constraintMatrix(10,1)=-1/7.8;
    
% % optimize the inner side of vv 
%     constraintMatrix(3,1)=0;
%     constraintMatrix(4,1)=0;
%     constraintMatrix(5,1)=0;
%     constraintMatrix(6,1)=0;
%     constraintMatrix(7,1)=0;
%     constraintMatrix(8,1)=0;
%     constraintMatrix(9,1)=0;
%     constraintMatrix(10,1)=0;
    
    
    
    % 0.0399 phi=9.475
%     constraintMatrix(3,1)=-1/9.8;
%     constraintMatrix(4,1)=-1/9.8;
%     constraintMatrix(5,1)=-1/9.2;
%     constraintMatrix(6,1)=-1/9.2;
%     constraintMatrix(7,1)=-1/8.6;
%     constraintMatrix(8,1)=-1/8.6;
%     constraintMatrix(9,1)=-1/7.8;
%     constraintMatrix(10,1)=-1/7.8;
end


%upper=lower for PF5-8
constraintMatrix(12,11)=-1;
constraintMatrix(12,12)=1;
constraintMatrix(14,13)=-1;
constraintMatrix(14,14)=1;
constraintMatrix(16,15)=-1;
constraintMatrix(16,16)=1;
constraintMatrix(18,17)=-1;
constraintMatrix(18,18)=1;



