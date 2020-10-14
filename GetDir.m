function myDir = GetDir(myShot)
myThousands=fix(myShot/1000);
myHundreds=fix(mod(myShot,1000)/100);
myShotSpan=myThousands*1000+fix((myHundreds)/2)*200;
%make sure the string is 5 digit
myDir=strcat('00000',num2str(myShotSpan));
n=length(myDir);
myDir=myDir(n-4:n);%stem of shotnumber for filename


