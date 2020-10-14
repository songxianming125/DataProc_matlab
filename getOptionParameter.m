function option=getOptionParameter(str)
optionsFileName=fullfile(getDProot,'options.xml');
xDoc=xmlread(optionsFileName);
xRoot=xDoc.getDocumentElement();
xMachine=xRoot.getElementsByTagName(str);
option=char(xMachine.item(0).getTextContent());

