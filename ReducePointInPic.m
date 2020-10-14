global   MyCurves 



for i=1:length(MyCurves)
    myX=MyCurves(i).x;
    myY=MyCurves(i).y;
    myStep=ceil(length(myX)/500);
    s=MyCurves(i).ChnlName;
    if myStep>1 && (~isempty(strfind(s,'Ip'))||~isempty(strfind(s,'Ioh'))||~isempty(strfind(s,'U_L_o_o_p'))||~isempty(strfind(s,'3Ha'))||~isempty(strfind(s,'Iv')))
        index=1:myStep:length(myX);
        MyCurves(i).x=myX(index);
        MyCurves(i).y=myY(index);
    end
    
end

