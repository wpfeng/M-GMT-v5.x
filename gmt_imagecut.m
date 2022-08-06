function gmt_imagecut(fimage,outname,roi,format)
%
%
%
% Created by FWP, @ GU, 2012-10-30
%
if nargin < 4
    format = 'integer';
end
%
info = sim_roirsc([fimage,'.rsc']);
%
tmp1 = [gmt_randname(4),'.grd'];
%
gmt_img2grd(fimage,tmp1,roi,format);
gmt_grd2roi(tmp1,outname);
%
cinfo = sim_roirsc([outname,'.rsc']);
%
cinfo.incidence   = info.incidence;
cinfo.heading_deg = info.heading_deg;
%
sim_croirsc([outname,'.rsc'],cinfo);
delete(tmp1);
%
