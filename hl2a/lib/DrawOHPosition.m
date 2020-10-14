function M=DrawOHPosition(u)

% u=0  mean no current
% u=1  mean with current


%draw the MP coil to reference the position



NumCoil=12;
X=linspace(0.905,0.905,NumCoil);
X([7 8 9 10 11 12])=[0.9745 1.087 1.208 1.725 2.049 2.475];
Y(1:NumCoil)=[0.1 0.286 0.472 0.658 0.844 1.030 1.236 1.359 1.411 1.398 1.172 0.3888];
C= 'g';



NumPoint=5;
Xr=zeros(NumPoint,NumCoil);
Yr=zeros(NumPoint,NumCoil);



for i=1:6
    Xr(:,i)=[-0.029; 0.029; 0.029; -0.029; -0.029];
    Yr(:,i)=[-0.073; -0.073; 0.073; 0.073; -0.073];
end

for i=7:9
    Xr(:,i)=[-0.031; 0.031; 0.031; -0.031; -0.031];
end
    Yr(:,7)=[-0.079; -0.079; 0.079; 0.079; -0.079];
    Yr(:,8)=[-0.068; -0.068; 0.068; 0.068; -0.068];
    Yr(:,9)=[-0.056; -0.056; 0.056; 0.056; -0.056];
for i=10:12
    Xr(:,i)=[-0.033; 0.033; 0.033; -0.033; -0.033];
end
    Yr(:,10)=[-0.030; -0.030; 0.030; 0.030; -0.030];
    Yr(:,11)=[-0.030; -0.030; 0.030; 0.030; -0.030];
    Yr(:,12)=[-0.018; -0.018; 0.018; 0.018; -0.018];


%-0.029 0.029 0.029 -0.029 -0.029;-0.029 0.029 0.029 -0.029 -0.029;-0.029 0.029 0.029 -0.029 -0.029;-0.029 0.029 0.029 -0.029 -0.029;-0.029 0.029 0.029 -0.029 -0.029];
%Yr(1:NumPoint)=[-0.04 -0.04 0.04 0.04 -0.04];


for i=1:NumCoil
    
    for j=1:NumPoint
            xc(j)=X(i)+Xr(j,i);
            ycu(j)=Y(i)+Yr(j,i);
            ycl(j)=-Y(i)+Yr(j,i);
    end
    
        if u==0 
            line(xc,ycu,'Color',C)
            line(xc,ycl,'Color',C)
        else
            fill(xc,ycu,C)
            line(xc,ycu,'Color',C)
            fill(xc,ycl,C)
            line(xc,ycl,'Color',C)
        end
        hold on
end
M=1;