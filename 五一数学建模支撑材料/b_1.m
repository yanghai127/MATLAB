%%
clear,clc;
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "Sheet1";
opts.DataRange = "B2:C3684";
opts.VariableNames = ["VarName2", "VarName3"];
opts.VariableTypes = ["double", "double"];
data = readtable("附件2：某地消防救援出警数据.xlsx", opts, "UseExcel", false);
data = table2array(data);
clear opts
for i = 1:length(data)
    data(i,1)=data(i,1)-42370;
end
