function gmt_makecpt(varargin)
%
%
% GMT 4.5.6
% +Input:
%        grd, grd file
%    mregion, the plot region, -R/xmin/xmax/ymin/ymax
%      outps, the outps, outname
%       inov, if overly existing ps...
%      outov, if permit later layer overlay
% +Example:
%  gmt_makecpt('gmt_colorn','gray','gmt_zstart','0,','gmt_zend','500',...
%              'gmt_cptname',gmt_cptname);
% Created by Feng, W.P., @ UoG, 03/10/2011
% modified by Feng, W.P.,@ UoG, 20/10/2011
%   Now working for colorful image overlaying on the relief ...
% Updated by Feng, W.P., @ NRCan, 2015-10-07
%   now it works for GMT5.x in Linux...
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_colorn     = 'seis';
gmt_zstart     = 0;
gmt_zend       = 1;
gmt_zinterv    = 0.001;
gmt_cptname    = 'color.cpt';
gmt_logrithm   = '  ';
gmt_iscontin   = 0;
gmt_isbackgr   = 0;
gmt_grdname    = [];
gmt_cptinput   = '';
gmt_isreverse  = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if ischar(gmt_zinterv)
    gmt_zinterv = str2double(gmt_zinterv);
end
%
if gmt_isbackgr==1
    background_type = ' -D ';
else
    background_type = ' ';
end
if gmt_iscontin == 1
    contin_type = ' -Z ';
else
    contin_type = ' ';
end
if isempty(gmt_grdname)
    zslices = [' -T' num2str(gmt_zstart) '/' num2str(gmt_zend) '/' num2str(gmt_zinterv) ' '];
else
    zslices = [' -T' gmt_grdname ' '];
end
%gmt_colorn
if strcmpi(gmt_cptinput,'')~=1
    gmt_colorn = gmt_cptinput;
end
if gmt_isreverse == 1
    revstr = ' -I ';
else
    revstr = ' ';
end
%
makecptstring = [' gmt makecpt -C' gmt_colorn ' ' background_type  ' ' contin_type ' ' ...
    gmt_logrithm ' ' zslices revstr ' >' gmt_cptname];
%

% gmt_gmtset('gmt_color_nan','255/255/255',...
%     'gmt_color_background','0/0/0',...
%     'gmt_color_foreground','255/255/255');
disp(makecptstring);
if nargin > 1
    system(makecptstring);
else
    disp('There is nothing to do ...');
end