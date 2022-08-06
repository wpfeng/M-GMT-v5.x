function gmt_grdmath(data1,data2,operator,outdata)
%
%
% Created by Feng, W.P., @ GU, 06/10/2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(data2)==0
    if isnumeric(data2)
        data2 = num2str(data2);
    end
    grdmathstr = ['gmt grdmath ' data1 ' ' data2 ' ' operator ' = ' outdata];
else
    grdmathstr = ['gmt grdmath ' data1 ' ' operator ' = ' outdata];
end
%
disp(grdmathstr);
system(grdmathstr);