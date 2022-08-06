function gmt_cutdem4grd(grd,dem,outdemgrd)
%
%
% Created by Feng, W.P., @ GU, 2011-10-31
% Modified by Feng, W.P., @ GU, 2011-11-07
%
[grdregion,xsize,ysize,zmin,zmax,wid,len] = gmt_grd2info(grd);
info  = sim_roirsc([dem,'.rsc']);
scale = fix(info.x_step/xsize);
%
if scale < 1
   downscale = 1;
else
   downscale = scale;
end
[data,~,~,info] = sim_defreadroi(dem,'integer',downscale,0,grdregion,0);
%
%
dim  = size(data);
s1   = ceil(len/dim(1));
s2   = ceil(wid/dim(2));
s    = (s1 > s2)*s1 + (s1 <= s2)*s2;
%
tdata= resizem(data,s,'nearest');
%whos tdata
data = tdata(1:len,1:wid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim        = size(data);
info.width = dim(2);
info.file_length = dim(1) ;
info.xmax  = info.width - 1;
info.ymax  = info.file_length -1;
info.x_step= xsize;%(grdregion(2)-grdregion(1))/info.width;
info.y_step= abs(ysize)*-1;%(grdregion(3)-grdregion(4))/info.file_length;
sim_roi2ENVI(data,info,'_FWP_DEM.dem');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3
   outdemgrd = [dem,'.grd'];
end
gmt_img2grd('_FWP_DEM.dem',outdemgrd,[],'float');
%
delete('_FWP_DEM.dem*');