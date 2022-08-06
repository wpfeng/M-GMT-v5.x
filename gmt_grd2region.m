function [grdregion,xsize,ysize,wid,len,sregion] = gmt_grd2region(grd)
%
%
% Created by Feng, W.P., @ GU, 03/10/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tempfile = [gmt_randname(5),'.info'];
system(['gmt grdinfo ',grd,' > ' tempfile]);
fid = fopen(tempfile,'r');

while ~feof(fid)
    tline = fgetl(fid);
    if isempty(strfind(tline,'x_min'))==0
       tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %20.15f %s %s %s %s %s %f');
       xmin = tmp{3};
       xmax = tmp{5};
       xsize  = tmp{7};
       wid    = tmp{11};
    end
    if isempty(strfind(tline,'y_min'))==0
       tmp = textscan(tline,'%s %s %20.15f %s %f %s %20.15f %s %s %s %s %s %f');
       ymin = tmp{3};
       ymax = tmp{5};
       ysize  = tmp{7};
       len    = tmp{11};
    end
end
fclose(fid);
grdregion = [xmin,xmax,ymin,ymax];
sregion   = [' -R',num2str(grdregion(1),'%20.15f'),'/',num2str(grdregion(2),'%20.15f'),'/',num2str(grdregion(3),'%20.15f'),'/',num2str(grdregion(4),'%20.15f'),' '];

%
%
delete(tempfile);