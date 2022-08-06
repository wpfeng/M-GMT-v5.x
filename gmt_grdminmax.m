function [x,y,z] = gmt_grdminmax(ingrd)
%
%
%
% Developed by Feng, W.P.,@ Yj, 2015-05-28
%
system(['gmt grdinfo ',ingrd,' -M |grep z_min > info.temp']);
%
fid = fopen('info.temp','r');
str = fgetl(fid);
fclose(fid);
%
tmp = textscan(str,'%s %s %f %s %s %s %f %s %s %f %s %f %s %s %s %f %s %s %f');
x(1) = tmp{7};
y(1) = tmp{10};
z(1) = tmp{3};
z(2) = tmp{12};
x(2) = tmp{16};
y(2) = tmp{19};


