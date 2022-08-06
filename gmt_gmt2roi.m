function gmt_gmt2roi(grd,outroi,outformat)
%
%
%
% Created by Feng, W.P., @ GU, 20/10/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 3
    outformat = 'float';
end
%
[re,xsi,ysi,~,~,wids,lens] = gmt_grd2info(grd);
info             = sim_roirsc();
info.width       = wids;
info.file_length = lens;
info.xmin        = 0;
info.xmax        = wids - 1;
info.ymin        = 0;
info.ymax        = lens - 1;
info.x_first     = re(1);
info.y_first     = re(4);
info.x_step      = xsi;
info.y_step      = -1*abs(ysi);
%
%
switch outformat
    case 'float'
        ofor = ' -Zf';
    otherwise
        ofor = ' -Zh';
end
grd2xyzstr       = ['grd2xyz ' grd ofor '> ',outroi];
disp(grd2xyzstr);
system(grd2xyzstr);
%
sim_croirsc([outroi,'.rsc'],info);
sim_rsc2envihdr([outroi,'.hdr'],info,'GMT',info.projection,info.utmzone);
%