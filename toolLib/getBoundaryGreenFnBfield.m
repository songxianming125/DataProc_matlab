function [BX,BY,BXp,BYp]=getBoundaryGreenFnBfield(Point,varargin)
%% update Green Function of Bfield at boundary
% Green function for points at boundary
if nargin>1
    pointType=varargin{1};
else
    pointType=0;
end


switch  pointType
    case 0 % diagnostic position
        
        BX=getappdata(0,'BXDiag'); %for PF coils
        BY=getappdata(0,'BYDiag');
        BXp=getappdata(0,'BXpDiag'); %for plasma
        BYp=getappdata(0,'BYpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXDiag',BX)
            setappdata(0,'BYDiag',BY)
            setappdata(0,'BXpDiag',BXp)
            setappdata(0,'BYpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
    case 1 % diagnostic position
        
        BX=getappdata(0,'BXDiag'); %for PF coils
        BY=getappdata(0,'BYDiag');
        BXp=getappdata(0,'BXpDiag'); %for plasma
        BYp=getappdata(0,'BYpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXDiag',BX)
            setappdata(0,'BYDiag',BY)
            setappdata(0,'BXpDiag',BXp)
            setappdata(0,'BYpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
    case 2 % diagnostic position
        
        BX=getappdata(0,'BXDiag'); %for PF coils
        BY=getappdata(0,'BYDiag');
        BXp=getappdata(0,'BXpDiag'); %for plasma
        BYp=getappdata(0,'BYpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXDiag',BX)
            setappdata(0,'BYDiag',BY)
            setappdata(0,'BXpDiag',BXp)
            setappdata(0,'BYpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
        
    case 3 % B field with probe size
        % poloidal and radial with different points
        % rmappdata(0,'BnDiag'); %for PF coils
        BX=getappdata(0,'BnDiag'); %for PF coils
        BY=getappdata(0,'BtDiag');
        BXp=getappdata(0,'BnpDiag'); %for plasma
        BYp=getappdata(0,'BtpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
%         if isempty(BX) % point is not the same
        else
            
            [Point,theta]=getDiagnostic(1);
            BPoint=Point(:,1:end-4);
            
            %    % unit cm->m
            
            
%             NX=5;
%             NY=5;
            NX=1;
            NY=1;
            
            
            numPoints=numel(theta);
            thetaM=reshape(theta,[numPoints 1]);
            cosTheta=cos(thetaM);
            sinTheta=sin(thetaM);
            
            %preparing the cos and sin value
            cosTheta=repmat(cosTheta,[1 NX*NY]);
            sinTheta=repmat(sinTheta,[1 NX*NY]);
            cosThetaVec=reshape(cosTheta,[1 numel(cosTheta)]);
            sinThetaVec=reshape(sinTheta,[1 numel(sinTheta)]);
            
            X0=BPoint(1,:);
            Y0=BPoint(2,:);
            X0=reshape(X0,[numPoints 1]);
            Y0=reshape(Y0,[numPoints 1]);
            X0=repmat(X0,[1 NX*NY]);
            Y0=repmat(Y0,[1 NX*NY]);
            
            
            % unit cm
            %% for poloidal B field
            % L=4.6;  % 4.5 +0.1(the diameter of coils is 0.05, two layers)
            W=2.6/100; % 2.5 +0.1(the diameter of coils is 0.05, two layers)
            H=2.0/100;
            
            
            StepX=W/NX/2;
            StepY=H/NY/2;
            %source
            [X2,Y2]=meshgrid(-W/2+StepX:2*StepX:W/2-StepX,-H/2+StepY:2*StepY:H/2-StepY);
            % matrix build  18*25
            X2=reshape(X2,[1 NX*NY]);
            X2=repmat(X2,[numPoints,1]);
            Y2=reshape(Y2,[1 NX*NY]);
            Y2=repmat(Y2,[numPoints,1]);
            
            % rotation in new coordinates(in Lab)
            X1=X0+X2.*cosTheta-Y2.*sinTheta;
            Y1=Y0+X2.*sinTheta+Y2.*cosTheta;
            
            
            mBPoint=[reshape(X1,[1 numel(X1)]);reshape(Y1,[1 numel(Y1)])];
            [BX,BY,BXp,BYp]=getFieldAtBoundary(mBPoint);
            
            
            BX=diag(cosThetaVec)*BX+diag(sinThetaVec)*BY;
%             Bt=-diag(sinThetaVec)*BX+diag(cosThetaVec)*BY;
            BXp=diag(cosThetaVec)*BXp+diag(sinThetaVec)*BYp;
%             Btp=-diag(sinThetaVec)*BXp+diag(cosThetaVec)*BYp;
            
            
            
            
            
            %% poloidal over
            
            
            
            %% for radial B field
            %     L=4.1;  % 4.0 +0.1(the diameter of coils is 0.05, two layers)
            W=2.2/100;
            H=1.7/100;  % 1.6 +0.1(the diameter of coils is 0.05, two layers)
            
            
            StepX=W/NX/2;
            StepY=H/NY/2;
            %source
            [X2,Y2]=meshgrid(-W/2+StepX:2*StepX:W/2-StepX,-H/2+StepY:2*StepY:H/2-StepY);
            % matrix build  18*25
            X2=reshape(X2,[1 NX*NY]);
            X2=repmat(X2,[numPoints,1]);
            Y2=reshape(Y2,[1 NX*NY]);
            Y2=repmat(Y2,[numPoints,1]);
            
            % rotation in new coordinates(in Lab)
            X1=X0+X2.*cosTheta-Y2.*sinTheta;
            Y1=Y0+X2.*sinTheta+Y2.*cosTheta;
            
            
            mBPoint=[reshape(X1,[1 numel(X1)]);reshape(Y1,[1 numel(Y1)])];
            [BX1,BY,BXp1,BYp]=getFieldAtBoundary(mBPoint);
            
%             Bn=diag(cosThetaVec)*BX+diag(sinThetaVec)*BY;
            BY=-diag(sinThetaVec)*BX1+diag(cosThetaVec)*BY;
            
%             Bnp=diag(cosThetaVec)*BXp+diag(sinThetaVec)*BYp;
            BYp=-diag(sinThetaVec)*BXp1+diag(cosThetaVec)*BYp;
            
           %% radial over
            setappdata(0,'BnDiag',BX)
            setappdata(0,'BtDiag',BY)
            setappdata(0,'BnpDiag',BXp)
            setappdata(0,'BtpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
   case 4 % B field with probe size
        % poloidal and radial with different points
        % rmappdata(0,'BnDiag'); %for PF coils
        BX=getappdata(0,'BnDiag'); %for PF coils
        BY=getappdata(0,'BtDiag');
        BXp=getappdata(0,'BnpDiag'); %for plasma
        BYp=getappdata(0,'BtpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
%         if isempty(BX) % point is not the same
        else
            
            [Point,theta]=getDiagnostic(1);
            BPoint=Point(:,1:end-4);
            
            %    % unit cm->m
            
            
            NX=5;
            NY=5;
            
            
            numPoints=numel(theta);
            thetaM=reshape(theta,[numPoints 1]);
            cosTheta=cos(thetaM);
            sinTheta=sin(thetaM);
            
            %preparing the cos and sin value
            cosTheta=repmat(cosTheta,[1 NX*NY]);
            sinTheta=repmat(sinTheta,[1 NX*NY]);
            cosThetaVec=reshape(cosTheta,[1 numel(cosTheta)]);
            sinThetaVec=reshape(sinTheta,[1 numel(sinTheta)]);
            
            X0=BPoint(1,:);
            Y0=BPoint(2,:);
            X0=reshape(X0,[numPoints 1]);
            Y0=reshape(Y0,[numPoints 1]);
            X0=repmat(X0,[1 NX*NY]);
            Y0=repmat(Y0,[1 NX*NY]);
            
            
            % unit cm
            %% for poloidal B field
            % L=4.6;  % 4.5 +0.1(the diameter of coils is 0.05, two layers)
            W=2.6/100; % 2.5 +0.1(the diameter of coils is 0.05, two layers)
            H=2.0/100;
            
            
            StepX=W/NX/2;
            StepY=H/NY/2;
            %source
            [X2,Y2]=meshgrid(-W/2+StepX:2*StepX:W/2-StepX,-H/2+StepY:2*StepY:H/2-StepY);
            % matrix build  18*25
            X2=reshape(X2,[1 NX*NY]);
            X2=repmat(X2,[numPoints,1]);
            Y2=reshape(Y2,[1 NX*NY]);
            Y2=repmat(Y2,[numPoints,1]);
            
            % rotation in new coordinates(in Lab)
            X1=X0+X2.*cosTheta-Y2.*sinTheta;
            Y1=Y0+X2.*sinTheta+Y2.*cosTheta;
            
            
            mBPoint=[reshape(X1,[1 numel(X1)]);reshape(Y1,[1 numel(Y1)])];
            [BX,BY,BXp,BYp]=getFieldAtBoundary(mBPoint);
            
            
            BX=diag(cosThetaVec)*BX+diag(sinThetaVec)*BY;
%             Bt=-diag(sinThetaVec)*BX+diag(cosThetaVec)*BY;
            BXp=diag(cosThetaVec)*BXp+diag(sinThetaVec)*BYp;
%             Btp=-diag(sinThetaVec)*BXp+diag(cosThetaVec)*BYp;
            
            
            
            
            
            %% poloidal over
            
            
            
            %% for radial B field
            %     L=4.1;  % 4.0 +0.1(the diameter of coils is 0.05, two layers)
            W=2.2/100;
            H=1.7/100;  % 1.6 +0.1(the diameter of coils is 0.05, two layers)
            
            
            StepX=W/NX/2;
            StepY=H/NY/2;
            %source
            [X2,Y2]=meshgrid(-W/2+StepX:2*StepX:W/2-StepX,-H/2+StepY:2*StepY:H/2-StepY);
            % matrix build  18*25
            X2=reshape(X2,[1 NX*NY]);
            X2=repmat(X2,[numPoints,1]);
            Y2=reshape(Y2,[1 NX*NY]);
            Y2=repmat(Y2,[numPoints,1]);
            
            % rotation in new coordinates(in Lab)
            X1=X0+X2.*cosTheta-Y2.*sinTheta;
            Y1=Y0+X2.*sinTheta+Y2.*cosTheta;
            
            
            mBPoint=[reshape(X1,[1 numel(X1)]);reshape(Y1,[1 numel(Y1)])];
            [BX1,BY,BXp1,BYp]=getFieldAtBoundary(mBPoint);
            
%             Bn=diag(cosThetaVec)*BX+diag(sinThetaVec)*BY;
            BY=-diag(sinThetaVec)*BX1+diag(cosThetaVec)*BY;
            
%             Bnp=diag(cosThetaVec)*BXp+diag(sinThetaVec)*BYp;
            BYp=-diag(sinThetaVec)*BXp1+diag(cosThetaVec)*BYp;
            
           %% radial over
            setappdata(0,'BnDiag',BX)
            setappdata(0,'BtDiag',BY)
            setappdata(0,'BnpDiag',BXp)
            setappdata(0,'BtpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
                
end
