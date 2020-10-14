function M=DrawMpPosition(u,l,varargin)

% u,l=0  mean no current
% u,l=1  mean with current


%draw the MP coil to reference the position
NumCoil=3;
X(1:NumCoil)=[1.355 1.5165 1.727];
Y(1:NumCoil)=[0.498 0.6753 0.56];
R(1:NumCoil)=[0.065 0.0875 0.065];
C(1:NumCoil)=['b' 'r' 'b'];

phi=0:pi/100:2*pi;




for i=1:NumCoil
    xc=X(i)+R(i)*cos(phi);
    ycu=Y(i)+R(i)*sin(phi);
    ycl=-Y(i)+R(i)*sin(phi);
    if u==0 
        plot(xc,ycu,C(i))
    else
        fill(xc,ycu,C(i))
    end
    
    hold on
    
    if l==0 
        plot(xc,ycl,C(i))
    else
        fill(xc,ycl,C(i))
    end
    
    if nargin>2
        if i~=varargin{1}
            plot(xc,ycl,C(i))
        else
            fill(xc,ycl,C(i))
        end
    end
    
    hold on
end
M=1;