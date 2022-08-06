function outdata = gmt_grdtrack(grdfile,prof,outname)
%
%
%
% Created by Feng,W.P., @ GU, 2012-09-10
%
comstr = ['grdtrack -G',grdfile,' ',prof,'>',outname];

%
disp(comstr);
system(comstr);
outdata = load(outname);