function gmt_basemap(roi,varargin)
%
%  
%  To create a base map with DEM relief
%  
%  Developed by Feng, W.P., @ IGP, Beijing, 2015-07-31
%
if nargin < 1
   disp('gmt_basemap(roi,varargin)');
   return
end
%
% Default parameters 
%
gmt_outps         = 'test.ps';
gmt_isrelief      = 0;
gmt_inputformat   = 'INTEGER';
iswrap            = 0;
%
gmt_xtitle        = [];
gmt_ytitle        = [];
gmt_proj          = ' -JM4i'; 
gmt_cptname       = gmt_cptdb('egg');
gmt_annotfontsize = '6p';
gmt_xoff          = '5i';
gmt_yoff          = '5i';
gmt_isov          = 0;
gmt_iscon         = 0;
gmt_outdpi        = 300;
gmt_version       = 5;
gmt_demgrd        = sar_dempath('etopo1'); % Provide an Etopo1 data for background topographic relief
%
gmt_unit                        = '(m)';
gmt_snew                        = 'SneW';
gmt_title                       = '';
gmt_frame_width                 = '0.02i';
gmt_frame_pen                   = '0.001i';
gmt_font_title                  = '13p,4,red';
gmt_ticklength                  = '0.025i';
gmt_annot_offset_primary        = '2p';
gmt_psscale_background_pen      = '0.03i';
gmt_psscale_background_fill     = '220/220/220';
gmt_psscale_background_offset   = '0.0250i';
gmt_psscale_background_offset_t = '0.0250i';
gmt_psscale_background_offset_b = '0.0150i';
gmt_psscale_background_offset_l = '0.0850i';
gmt_psscale_background_offset_r = '0.0350i';
gmt_colorbarxoffset             = '0.385i';
gmt_colorbaryoffset             = '0.20i';
gmt_graddifusion                = 0.5;
gmt_azimuth2                    = 135;
gmt_azimuth1                    = 90;
gmt_scalecof                    = 1;
gmt_mul                         = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_gradientmethod              = 'A';
gmt_demdisplay                  = '0.45';
gmt_scale                       = 2;
gmt_axstep                      = '2';
gmt_aystep                      = '2';
gmt_minwrap                     = [];
gmt_maxwrap                     = [];
gmt_zinterv                     = [];
gmt_backcol                     = '0/0/0';
gmt_forecol                     = '255/255/255';
%
% ' -Lfx0.45i/0.41i/0/50k+lkm+jt '
%
gmt_lengthscale                 = [];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read parameters from inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    %
    var = varargin{ni};
    val = varargin{ni+1};
    eval([var,'= val;']);
    %
end
% 
if exist(gmt_cptname,'file') && ~strcmpi(gmt_cptname,'globe')
    %
    colormapt = gmt_importcpt(gmt_cptname);
else
    colormapt = [];
end
%
if ~isnan(colormapt)
    %
    backgroundcol = fix(colormapt(2,:).*255);
    foregroundcol = fix(colormapt(end-1,:).*255);
end
%
if isempty(gmt_backcol)
    gmt_backcol   = [num2str(backgroundcol(1)),'/',...
                     num2str(backgroundcol(2)),'/',...
                     num2str(backgroundcol(3))];
end
%
if isempty(gmt_forecol)
    gmt_forecol = [num2str(foregroundcol(1)),'/',...
               num2str(foregroundcol(2)),'/',...
               num2str(foregroundcol(3))];
end
%
if ~exist(gmt_demgrd,'file')
    %
    disp('gmt_basemap: You have to give a correct dem file. Please check first');
    return
end
%
% Cut Dem based on input ROI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temporary DEM file used in plotting
%
tmpDem      = 'Tmp_basemap.dem';
plot_demgrd = [];
sar_cutroi(gmt_demgrd,tmpDem,roi,gmt_scale,gmt_inputformat);
%
data = sim_readimg(tmpDem,'datatype',gmt_inputformat,'isplot',0);

if isempty(gmt_minwrap)
    %
    cdata = data(~isnan(data));
    gmt_minwrap = min(cdata(:))*0.95;
    gmt_maxwrap = max(cdata(:))*1.15;
    gmt_zinterv = fix((gmt_maxwrap-gmt_minwrap)/2.5);
end
%
%
if gmt_isrelief == 1
    plot_demgrd = tmpDem;
end
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_gmtset('gmt_color_nan',               '255/255/255',...
           'gmt_paper_media',             'A0',...
           'gmt_annot_font_size_primary', gmt_annotfontsize,...
           'gmt_tick_length',             gmt_ticklength,...
           'gmt_color_background',        gmt_backcol,...
           'gmt_color_foreground',        gmt_forecol,...
           'gmt_frame_pen',               gmt_frame_pen,...
           'gmt_annot_offset_primary',    gmt_annot_offset_primary,...
           'gmt_oblique_annotation',      '32' ,...
           'gmt_frame_width',             gmt_frame_width,...
           'gmt_font_title',              gmt_font_title);
%
outregion = gmt_img2ps(tmpDem,....
        'gmt_inputformat',                gmt_inputformat,...
        'gmt_xoff',                       gmt_xoff,...
        'gmt_scale',                      1,...
        'gmt_demgrd',                     plot_demgrd,...
        'gmt_yoff',                       gmt_yoff,...
        'gmt_psscale_background_pen',     gmt_psscale_background_pen,...
        'gmt_psscale_background_fill',    gmt_psscale_background_fill,...
        'gmt_psscale_background_offset',  gmt_psscale_background_offset,...
        'gmt_psscale_background_offset_t',gmt_psscale_background_offset_t,...
        'gmt_psscale_background_offset_b',gmt_psscale_background_offset_b,...
        'gmt_psscale_background_offset_l',gmt_psscale_background_offset_l,...
        'gmt_psscale_background_offset_r',gmt_psscale_background_offset_r,...
        'gmt_proj',                       gmt_proj,...
        'gmt_outps',                      gmt_outps,....
        'gmt_iscon',                      gmt_iscon,...
        'gmt_isov',                       gmt_isov,...
        'gmt_xtitle',                     gmt_xtitle,...
        'gmt_ytitle',                     gmt_ytitle,....
        'gmt_title',                      gmt_title,...
        'gmt_colorn',                     gmt_cptname,...
        'gmt_nanvalue',                   200,...
        'gmt_azimuth1',                   gmt_azimuth1,...
        'gmt_azimuth2',                   gmt_azimuth2,...
        'gmt_scalecof',                   gmt_scalecof,...
        'gmt_axstep',                     gmt_axstep,...
        'gmt_aystep',                     gmt_aystep,...
        'gmt_snew',                       gmt_snew,...
        'iswrap',                         iswrap,...
        'gmt_demdisplay',                 gmt_demdisplay,...
        'gmt_graddifusion',               gmt_graddifusion,...
        'gmt_gradientmethod',             gmt_gradientmethod,...
        'gmt_cptname',                    [],...
        'minwrap',                        gmt_minwrap,...
        'maxwrap',                        gmt_maxwrap,...
        'gmt_minwrap',                    gmt_minwrap,...
        'gmt_maxwrap',                    gmt_maxwrap,...
        'gmt_colorbarxoffset',            gmt_colorbarxoffset,...
        'gmt_colorbaryoffset',            gmt_colorbaryoffset,...
        'gmt_colorbarwidth',              '0.07i',...
        'gmt_colorbarlength',             '0.6i',...
        'gmt_outdpi',                     gmt_outdpi,...
        'gmt_zinterv',                    gmt_zinterv,...
        'gmt_unit',                       gmt_unit,...
        'gmt_mul',                        gmt_mul,...
        'gmt_lengthscale',                gmt_lengthscale,...
        'gmt_version',                    gmt_version);

