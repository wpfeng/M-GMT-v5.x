function gmt_psbasemap(varargin)
%
%
% GMT 4.5.6 
% +Input:
%        grd, grd file
%    mregion, the plot region, -R/xmin/xmax/ymin/ymax
%      outps, the outps, outname
%       inov, if overly existing ps...
%      outov, if permit later layer overlay
% 
% Created by Feng, W.P., @ GU, 03/10/2011
% modified by Feng, W.P.,@ GU, 20/10/2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_mregion = ' -R0/1/0/1 ';
gmt_proj_xy = ' -J ';
gmt_proj_z  = ' ';
gmt_outps   = 'test.ps';
gmt_isov    = 0;
gmt_iscon   = 0;
gmt_xoff    = '0i';
gmt_yoff    = '0i';
gmt_axoff  = '50';
gmt_ayoff  = '50';
gmt_azoff  = '';
gmt_xtitle  = '';
gmt_ytitle  = '';
gmt_ztitle  = '';
gmt_backcolor = '';
gmt_lscale    = ' -L';
gmt_snew      = 'NEsw';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gmt_isov==1
    type1 = ' -O >>';
else
    type1 = ' >';
end
if gmt_iscon == 1
    type2 = ' -K ';
else
    type2 = ' ';
end
gmt_otype = [type2, type1];
if strcmpi(gmt_backcolor,'')~=1
    gmt_backflag = ' -G';
else
    gmt_backflag = ' ';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psbasemapstr = ['psbasemap  ',gmt_mregion,' ',gmt_proj_xy,' ',gmt_proj_z,' ', gmt_iscon,' -B' gmt_axoff ':"',gmt_xtitle,'":/' gmt_ayoff,':"',gmt_ytitle,'":/', ...
               gmt_azoff,':"',gmt_ztitle,'":',gmt_snew,' -X' gmt_xoff, ' -Y' gmt_yoff,' ',gmt_backflag  gmt_backcolor ' ' gmt_lscale ' ' gmt_otype, gmt_outps];
disp(psbasemapstr);
system(psbasemapstr);
%disp(colorbarstr);
%system(colorbarstr);
%
if gmt_iscon ~=1
   ps2rasterstr = ['ps2raster ' gmt_outps ' -Tg -A -E300'];
   system(ps2rasterstr);
end
