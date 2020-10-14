function [varargout]=autopower_t_f(varargin)
% time and frequency dominant resoluble spectrum
%    autopower_t_f(signal,time,fs) or 
%    autopower_t_f(signal,time ,fs,nfft,shift,base,colortype,label_signal)
% developed by Dr. Zhong Wulv
%%

% narginchk(2, 7) % 2<=nargin<=7
signal=varargin{1};% raw signal
time=varargin{2};% time series of the raw signal
if length(time)>1 && (time(2)-time(1))>0
    fs=1/(time(2)-time(1));% sample frequensy
else
    error('SXM:time sequence is wrong!')
end
if nargin==2
    nfft=1024;% frame length
    shift=128;% the shift of adjacent frames  
    label_signal=0;
elseif nargin==7
    nfft=varargin{3};
    shift=varargin{4};
    base=varargin{5};%the base of spectrum,above of which,the spectrum values
    % are nomalized between 0 and 1,and below of which,they are replaced by
    % the base value.
    colortype=varargin{6};% colormap label,if colortype is equal to 1,the colormap
    % is hot,else it is gray.
    label_signal=varargin{7};
else
    errordlg('The number of input is wrong')
end
%-------------------
nframe=floor((length(signal)-nfft)/shift)+1; % frame number
A=zeros(nfft/2,nframe);
f=(1:nfft/2)*fs/nfft;%f=f/1000;%frequency  Hz->kHz Dr. Song Xianming Comment
for i=1:nframe
    n1=(i-1)*shift+1;n2=n1+(nfft-1);
    y=signal(n1:n2);
    if label_signal==0
        data=y-mean(y);
    else
        data=y;
    end    
%    data=hilbert(data);%希尔伯特变换为解析信号
    data=data.*hanning(nfft);
    p=fft(data);ph=p(2:nfft/2+1);
    power=(ph.*conj(ph));
    tout(i)=mean(time(n1:n2));%  time of each frame
    A(:,i)=power;
end
%--------------------
A=10*log10(A);
if nargin==3
    base=min(min(A));
    colortype=1;
end
A1=(A>base);A2=(A<=base);
B=A.*A1+base.*A2;
C=(B-base)/(max(max(B))-base); %normalize to have max=1
%


varargout{1}=tout;
varargout{2}=f;
varargout{3}=(C);

return
narginchk(2, 7) % 2<=nargin<=7
signal=varargin{1};% raw signal
time=varargin{2};% time series of the raw signal
if length(time)>1 && (time(2)-time(1))>0
    fs=1/(time(2)-time(1));% sample frequensy
else
    error('SXM:time sequence is wrong!')
end
if nargin==2
    nfft=1024;% frame length
    shift=128;% the shift of adjacent frames  
    label_signal=0;
elseif nargin==7
    nfft=varargin{3};
    shift=varargin{4};
    base=varargin{5};%the base of spectrum,above of which,the spectrum values
    % are nomalized between 0 and 1,and below of which,they are replaced by
    % the base value.
    colortype=varargin{6};% colormap label,if colortype is equal to 1,the colormap
    % is hot,else it is gray.
    label_signal=varargin{7};
else
    errordlg('The number of input is wrong')
end
%-------------------
nframe=floor((length(signal)-nfft)/shift)+1; % frame number
A=zeros(nfft/2,nframe);
f=(1:nfft/2)*fs/nfft;f=f/1000;%frequency  Hz->kHz Dr. Song Xianming Comment
for i=1:nframe
    n1=(i-1)*shift+1;n2=n1+(nfft-1);
    y=signal(n1:n2);
    if label_signal==0
        data=y-mean(y);
    else
        data=y;
    end    
%    data=hilbert(data);%希尔伯特变换为解析信号
data=data.*hanning(nfft);
    p=fft(data);ph=p(2:nfft/2+1);
    power=(ph.*conj(ph));
    tout(i)=mean(time(n1:n2));%  time of each frame
    A(:,i)=power;
end
%--------------------
A=10*log10(A);
if nargin==3
    base=min(min(A));
    colortype=1;
end
A1=(A>base);A2=(A<=base);
B=A.*A1+base.*A2;
C=(B-base)/(max(max(B))-base);
%

% --------------------figure 1
 figure
if colortype==1
    colormap(jet);
else
    mycolor=gray;mycolor=mycolor(64:-1:1,:);
    colormap(mycolor);
end

imagesc(tout,f,(C))
shading interp
colorbar
axis xy %The x-axis is horizontal with values increasing from left to right. 
% The y-axis is vertical with values increasing from bottom to top.
xlabel('t (ms)');ylabel('f (kHz)')
varargout{1}=tout;
varargout{2}=f;
varargout{3}=(C);


