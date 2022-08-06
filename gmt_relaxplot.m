function gmt_relaxplot(innumber,relax)
%
%
% convert for quick viewing
% innumber = '005';
% developed by FWP, @IGPP of SIO, UCSD, 2013-08-11
%
if nargin < 2 || isempty(relax)
    relax    = '';
end
gmt_outps = ['gmt',relax,'-',innumber,'.ps'];
%
ein      = [innumber,relax,'-east.grd'];
nin      = [innumber,relax,'-north.grd'];
uin      = [innumber,relax,'-up.grd'];
gmt_grd2roi(ein,'east.img','f');
gmt_grd2roi(nin,'north.img','f');
gmt_grd2roi(uin,'up.img','f');%
%
%gmt_outps = 'gmt_enu.ps';
%
gmt_gmtset('gmt_paper_media','A0',...
    'gmt_color_background','173/0/0',...
    'gmt_color_foreground','0/3/207');
gmt_img2ps('east.img',...
    'gmt_proj', ' -JX4i ',...
    'gmt_xoff','1i',...
    'gmt_yoff','1i',...
    'gmt_snew','sNeW',...
    'gmt_axstep','30',...
    'gmt_aystep','30',...
    'gmt_minwrap',-0.1,...
    'gmt_maxwrap',0.1,...
    'gmt_zinterv','0.1',...
    'gmt_isov',0,...
    'gmt_iscon',1,...
    'gmt_unit','slip(m)',...
    'gmt_outps',gmt_outps);
%
gmt_img2ps('north.img',...
    'gmt_proj', ' -JX4i ',...
    'gmt_xoff','4i',...
    'gmt_yoff','0i',...
    'gmt_axstep','30',...
    'gmt_aystep','30',...
    'gmt_minwrap',-0.1,...
    'gmt_maxwrap',0.1,...
    'gmt_zinterv','0.1',...
    'gmt_snew','sNew',...
    'gmt_unit','slip(m)',...
    'gmt_isov',1,...
    'gmt_iscon',1,...
    'gmt_outps',gmt_outps);
gmt_img2ps('up.img',...
    'gmt_proj', ' -JX4i ',...
    'gmt_xoff','4i',...
    'gmt_yoff','0i',...
    'gmt_axstep','30',...
    'gmt_aystep','30',...
    'gmt_minwrap',-0.05,...
    'gmt_maxwrap',0.05,...
    'gmt_zinterv','0.05',...
    'gmt_snew','sNEw',...
    'gmt_isov',1,...
    'gmt_unit','slip(m)',...
    'gmt_iscon',0,...
    'gmt_outps',gmt_outps);