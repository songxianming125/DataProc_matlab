function [ChnlName,ChnlNum]=SetProbeChnl
NumProbe=18;
FirstNum=172;
CName1='FBIrad_00';
CName2='FBIpol_00';

for i=1:NumProbe
    myStr=int2str(i);
    if i<10
        myStr=strcat('0',myStr);
    end    
    Name=strrep(CName1,'00',myStr);
    ChnlName(i,1)={Name};
    ChnlNum(i,1)=FirstNum+2*(i-1);
    Name=strrep(CName2,'00',myStr);
    ChnlName(i,2)={Name};
    ChnlNum(i,2)=FirstNum+2*(i-1)+1;
end