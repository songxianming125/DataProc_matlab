function type=getGesture(trajectoryPoint)
%% definition 
% 0 no trajectory
% 1 first quadrant, anti-clockwise 
% 2 second quadrant, anti-clockwise 
% 3 third quadrant, anti-clockwise 
% 4 fourth quadrant, anti-clockwise 


% 5 first quadrant, clockwise 
% 6 second quadrant, clockwise 
% 7 third quadrant, clockwise 
% 8 fourth quadrant, clockwise 

% 9 zoom in=from lefttop to rightbottom 
% 10 zoom out=from  rightbottom to lefttop

% 11 down
% 12 up
% 13 left
% 14 right

% 15 =from  righttop to leftbottom 
% 16 =from rightbottom to  lefttop

if isempty(trajectoryPoint)
    type=0;
    return
end

X=trajectoryPoint(1,:);
Y=trajectoryPoint(2,:);
maxX=max(X);
minX=min(X);
midX=(maxX+minX)/2;
delX=maxX-minX;

maxY=max(Y);
minY=min(Y);
midY=(maxY+minY)/2;
delY=maxY-minY;



aspectRatio=delX/(delY+0.001);

if aspectRatio<0.2 % updown
    if Y(1)>Y(end)
        type=11; %down
    else % Y(1)<Y(end)
        type=12; %up
    end
elseif aspectRatio>0.2 && aspectRatio<5 % square
    [r,k,b] = regression(X,Y);
    if abs(r)>0.8   % linear
        if X(1)<X(end) && Y(1)>Y(end)
            type=9; %9 zoom in=from lefttop to rightbottom
        elseif X(1)>X(end) && Y(1)<Y(end)
            type=10; % 10 zoom out=from  rightbottom to lefttop
        elseif X(1)>X(end) && Y(1)>Y(end)
            type=15; % 15 =from  righttop to leftbottom
        elseif X(1)<X(end) && Y(1)<Y(end)
            type=16; % 16 =from leftbottom to righttop  
        else
            type=0;
        end
    else  % not linear
        N1=sum(X>midX & Y>midY);  % first-quadrant 
        N2=sum(X<midX & Y>midY); % second-quadrant 
        N3=sum(X<midX & Y<midY); % third-quadrant 
        N4=sum(X>midX & Y<midY); % fourth-quadrant 
        Ns=[N3 N4 N1 N2];
        
        [Nmin,index]=min(Ns);   % where is less
        offset=4;
        switch index
            case 1  % third less
                if X(1)>X(end)
                    type=index; % acw first-quadrant
                else
                    type=offset+index; % cw first-quadrant
                end
            case 2
                if X(1)>X(end)
                    type=index; % acw second-quadrant
                else
                    type=offset+index; % cw second-quadrant
                end
                
            case 3
                if X(1)<X(end)
                    type=index; % acw third-quadrant
                else
                    type=offset+index; % cw third-quadrant
                end
            case 4
                if X(1)<X(end)
                    type=index; % acw fourth-quadrant
                else
                    type=offset+index; % cw  fourth-quadrant
                end
        end
    end
else aspectRatio>5 % leftright
    if X(1)>X(end)
        type=13; %left
    else % X(1)<X(end)
        type=14; %right
    end
end
return
