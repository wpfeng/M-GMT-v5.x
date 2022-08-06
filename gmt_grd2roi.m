function gmt_grd2roi(grdfile,outroi,outformat,inrsc)
%
%
% Created by Feng, W.P., @ UoG, 2012-08-08
% Updated by Feng, W.P., @ Yj, 2015-04-28
% -> make it work for GMT5.x
%
if nargin < 1
    disp('gmt_grd2roi(grdfile,outroi,outformat,inrsc)');
    return
end
%
if nargin < 3 || isempty(outformat)
    outformat = 'f';
end
if nargin >= 4 
    outinfo = sim_roirsc(inrsc);
else
    outinfo = [];
end
%
% Updated for GMT5.x, by Feng,W.P.,@YJ, 2015-04-28
%
gmt_commond = [' gmt grd2xyz ',grdfile,' -ZTL',MCM_rmspace(outformat), ' >',outroi];
disp(gmt_commond);
system(gmt_commond);
%
info = sim_roirsc();
if isempty(outinfo)==0
    info = outinfo;
end
%
[grdregion,xsize,ysize,t_mp,t_mp,wid,len] = gmt_grd2info(grdfile);
info.width       = wid;
info.file_length = len;
info.x_first     = grdregion(1);
info.y_first     = grdregion(4);
info.x_step      = xsize;
info.y_step      = -1*abs(ysize);
%
sim_croirsc([outroi,'.rsc'],info);
sar_rsc2hdr([outroi,'.rsc'],[outroi,'.hdr'])