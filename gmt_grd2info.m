function [grdregion,xsize,ysize,zmin,zmax,wid,len,mregion] = gmt_grd2info(grd)
%
%
% Created by Feng, W.P., @ GU, 03/10/2011
% Updated by Feng, W.P., @ NRCan, 2015-10-07
% make it work in linux system...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile = [gmt_randname(5),'.info'];
disp([' gmt grdinfo ',grd,' > ',tempfile]);
system([' gmt grdinfo ',grd,' > ',tempfile]);
fid = fopen(tempfile,'r');

while ~feof(fid)
    tline = fgetl(fid);
    if isempty(strfind(tline,'x_min'))==0
       %tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %20.15f %s %s %s %d ');
       tmp = textscan(tline,'%s','delimiter',' ');
       tmp = tmp{1};
       %xmin = textscan(tmp{3},'%f %s');
       xmin = str2double(tmp{3});
       %xmax = textscan(tmp{5},'%f %s');
       xmax = str2double(tmp{5});
       %xsize  = textscan(tmp{6},'%f %s');
       xsize  = str2double(tmp{7});
       %wid    = textscan(tmp{7},'%f');
       tmp = textscan(tline,'%s','delimiter','nx:');
       wid = tmp{1};
       wid = str2double(wid{end});
       
    end
    if isempty(strfind(tline,'y_min'))==0
       tmp = textscan(tline,'%s','delimiter',' ');
       tmp = tmp{1};
       %xmin = textscan(tmp{3},'%f %s');
       ymin = str2double(tmp{3});
       %xmax = textscan(tmp{5},'%f %s');
       ymax = str2double(tmp{5});
       %xsize  = textscan(tmp{6},'%f %s');
       ysize  = str2double(tmp{7});
       tmp = textscan(tline,'%s','delimiter','ny:');
       twid = tmp{1};
       len = str2double(twid{end});
       
    end
    if isempty(strfind(tline,'z_min'))==0
        tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %s');
        zmin = tmp{3};
        zmax = tmp{5};
    end
    
end
fclose(fid);
grdregion = [xmin,xmax,ymin,ymax];
mregion   = [' -R',num2str(xmin),'/',...
                   num2str(xmax),'/',...
                   num2str(ymin),'/',...
                   num2str(ymax),' '];
%
delete(tempfile);