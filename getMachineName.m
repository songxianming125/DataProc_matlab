function machine= getMachineName
machine=getappdata(0,'machine');
if isempty(machine)
    machine=getOptionParameter('machine');
    setappdata(0,'machine',machine);
end
end

