function gmt_plotgps(outdata,gmt_outps,gmt_scale,gmt_iscon,incolor,gmt_lwid,gmt_arrowtype)
%
%
%
% outdata,
%  [x,y,
% A simple script to plot GPS data with arrows
% Developed by FWP, @ IGPP of SIO, UCSD, 2013-11-03
% A new keyword was added, gmt_arrowtype, by FWP, @ GU, 2014-01-24
% 0.05/0.2/0.085
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 5
    incolor = '255/0/0';
end
if nargin < 6
    gmt_lwid = '0.005c';
end
%
if nargin < 4
    gmt_iscon = 1;
end
if nargin < 3
    gmt_scale = '0.3';
end
%
% ?AArrow_width/Head_length/Head_width 
if nargin < 7
   gmt_arrowtype = '0.05/0.2/0.085';
end
%
tmpfile = 'temp/tmp_temp.dat';
%
if ~exist('temp','dir')
    mkdir('temp')
end
%
fid = fopen(tmpfile,'w');
fprintf(fid,'%f %f %f %f %f %f %f \n',outdata');
fclose(fid);
%
gmt_proj    = ' -J ';
gmt_mregion = ' -R';
gmt_xoff    = '0i';
gmt_yoff    = '0i';
gmt_snew    = '';
gmt_isov    = 1;
gmt_lcolor  = ',10/10/10';
gmt_fcolor  = incolor;
gmt_velout  = ' ';%-N ';
gmt_axstep  = '';
gmt_aystep  = '';
%
%
gmt_psvelo(...
    'gmt_velout',   gmt_velout,...
    'gmt_datainp',  tmpfile,...
    'gmt_proj',     gmt_proj,...
    'gmt_mregion',  gmt_mregion,...
    'gmt_iscon',    gmt_iscon,...
    'gmt_axstep',   gmt_axstep,...
    'gmt_lwid',     gmt_lwid,...
    'gmt_lcolor',   gmt_lcolor,...
    'gmt_fcolor',   gmt_fcolor,...
    'gmt_aystep',   gmt_aystep,...
    'gmt_scale',    gmt_scale,...
    'gmt_snew',     gmt_snew,...
    'gmt_arrowtype',gmt_arrowtype,....
    'gmt_xoff',     gmt_xoff,...
    'gmt_yoff',     gmt_yoff,...
    'gmt_isov',     gmt_isov,...
    'gmt_outps',    gmt_outps);

