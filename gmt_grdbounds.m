function [x,y] = gmt_grdbounds(ingrd)
%
%
%
% Developed by Feng, W.P.,@ Yj, 2015-05-28
% Updated by Feng, W.P., @NRCan, 2015-10-09
%
system(['gmt grdinfo ',ingrd,' -M |grep x_min > info.x']);
%
fid = fopen('info.x','r');
str = fgetl(fid);
fclose(fid);
%
tmp = textscan(str,'%s %s %f %s %f %s %f %s %s %s %f ');
x(1) = tmp{3};
x(2) = tmp{5};
x(3) = tmp{7};
x(4) = tmp{11};
% 
% 
system(['gmt grdinfo ',ingrd,' -M |grep y_min > info.y']);
%
fid = fopen('info.y','r');
str = fgetl(fid);
fclose(fid);
%
tmp = textscan(str,'%s %s %f %s %f %s %f %s %s %s %f ');
y(1) = tmp{3};
y(2) = tmp{5};
y(3) = tmp{7};
y(4) = tmp{11};

