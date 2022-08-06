function gmt_dirplot_sio(ints,gmt_outps,iswrap,wraprange,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A new version for batch plotting...
% By fWP, @IGPP of SIO, UCSD, 2013-11-28
% Updated by Feng, W.P., @ YJ, 2015-04-20
% -> make it available for GMT5.x
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
   %
   disp('gmt_dirplot_sio(ints,gmt_outps,iswrap,wraprange,varargin)');
   disp(' varargin includes...')
   disp('   gmt_profile  -  a structure with x,y,titles,bufferwidth');
   disp('');
   return
end
%
%
gmt_annotfontsize = '9p';
gmt_ticklength    = '0.05c';
gmt_trackyscale   = 0.25;
gmt_trackxscale   = 0.75;
gmt_titlexoffset  = 0.001;
gmt_titleyoffset  = 0.075;
gmt_xtitle        = [];
gmt_ytitle        = [];
gmt_projtype      = 'M';
faultpoly         = 'geo_08mw63POLY.inp';
numraw            = 3;
numcol            = 9;
intitle           = [];
gmt_trackinfolengthscale = '0.25';
%
gmt_cptname  = gmt_cptdb('egg');
%
if exist(gmt_cptname,'file')
    colormapt     = gmt_importcpt(gmt_cptname);
else
    colormapt = [];
end
colormapt = [];%
if ~isnan(colormapt)
    %
    backgroundcol = fix(colormapt(1,:).*255);
    foregroundcol = fix(colormapt(end,:).*255);
    backcol       = [num2str(backgroundcol(1)),'/',...
                     num2str(backgroundcol(2)),'/',...
                     num2str(backgroundcol(3))];
    %
    forecol = [num2str(foregroundcol(1)),'/',...
        num2str(foregroundcol(2)),'/',...
        num2str(foregroundcol(3))];
else
    backcol = '0/0/0';
    forecol = '255/255/255';
end
gmt_istrackinfo = 0;
gmt_xoff        = [];
gmt_yoff        = [];
gmt_superiscon= [];
gmt_superisov = [];
gmt_supersnew = '';
gmt_constantsnew = '';
gmt_mul       = 1;
gmt_outdpi    = 300;
gmt_version   = 5;
gmt_demgrd    = sar_dempath('ETOPO1');           % Provide a srtm data for background topographic relief
gmt_unit      = 'Rad';
gmt_title     = '';                            % First Test using GMT5.x';
gmt_profilefontsize             = '9p';
gmt_profilelableshift           = 1;
gmt_profilefontcolor            = 'white,-=0.1p,black';
text_size                       = '15p';
text_fontcolor                  = 'white';
text_pen                        = '';
text_relativeloc                = '';
text_backcolor                  = '';%'10/10/10';
text_edgewidth                  = '';%;'0.01i'  % the parameter for plotting an outline of a text string...
text_fillcolor                  = 'black';%50/50/50';
gmt_frame_width                 = '0.02i';
gmt_frame_pen                   = '0.001i';
gmt_font_title                  = '13p,4,red';
gmt_annot_offset_primary        = '2p';
gmt_psscale_background_pen      = '0.03i';
gmt_psscale_background_fill     = '220/220/220';
gmt_psscale_background_offset   = '0.0250i';
gmt_psscale_background_offset_t = '0.0250i';
gmt_psscale_background_offset_b = '0.0150i';
gmt_psscale_background_offset_l = '0.0850i';
gmt_psscale_background_offset_r = '0.0350i';
gmt_colorbarxoffset             = '0.40i';
gmt_colorbaryoffset             = '0.25i';
gmt_faultstype                  = ' -Sf0.35i/0.1i+r+t+o0.1i ';
gmt_graddifusion                = 0.5;
gmt_azimuth2                    = 135;
gmt_azimuth1                    = 90;
gmt_scalecof                    = 1;
%
% Profile
gmt_profile                     = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_gradientmethod              = 'A';
gmt_demdisplay                  = '0.45';
xwid        = 2.5;
minwrap     = [];
maxwrap     = [];
gmt_scale   = 2;
gmt_axstep  = '0.75';
gmt_aystep  = '0.5';
gmt_minwrap  = [];
gmt_maxwrap  = [];
gmt_zinterv  = [];
gmt_faulttop = [];
gmt_faulttopwid = '0.1c';
%gmt_faultlinecolor = ',0/0/0';
gmt_faultlinewid   = '0.03c,black';
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    var = varargin{ni};
    val = varargin{ni+1};
    eval([var,'= val;']);
    %
end
if isempty(gmt_faulttop)
    faulttopo = 'geo_08mw63TOP.inp';
else
    faulttopo = gmt_faulttop;
end
%
if isempty(gmt_minwrap)
    gmt_minwrap = -1*abs(wraprange);
end
if isempty(gmt_maxwrap)
    gmt_maxwrap = abs(wraprange);
end
if isempty(gmt_zinterv)
    gmt_zinterv = sum(abs([gmt_maxwrap,gmt_minwrap]))./2;
end
%
if isempty(minwrap)
    minwrap = gmt_minwrap;
end
%
if isempty(maxwrap)
    maxwrap = gmt_maxwrap;
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
gmt_gmtset('gmt_color_nan',               '255/255/255',...
           'gmt_paper_media',             'A0',...
           'gmt_annot_font_size_primary', gmt_annotfontsize,...
           'gmt_tick_length',             gmt_ticklength,...
           'gmt_color_background',        backcol,...
           'gmt_frame_pen',               gmt_frame_pen,...
           'gmt_annot_offset_primary',    gmt_annot_offset_primary,...
           'gmt_color_foreground',        forecol,...
           'gmt_oblique_annotation',      '32' ,...
           'gmt_frame_width',             gmt_frame_width,...
           'gmt_font_title',              gmt_font_title);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if numel(gmt_mul)<numel(ints)
    gmt_mul = zeros(numel(ints),1)+gmt_mul(1);
end
%gmt_titleyoffset
if numel(gmt_titleyoffset)<numel(ints)
    gmt_titleyoffset = zeros(numel(ints),1)+gmt_titleyoffset(1);
end
%
if ischar(ints)
    nints = 1;
else
    nints = numel(ints);
end
%
for ni = 1:nints
    %
    if iscell(ints)
        cint = ints{ni};
    else
        if isstruct(ints)
        cint  = ints(ni).name;
        else
            cint = ints;
        end
            
    end
    %
    fcrsc = [cint,'.rsc'];
    fcint = cint;
    %
    scale = gmt_img2xyratio([cint,'.rsc']);
    %
    yhigh = xwid.*scale*-1;
    %
    [t_mp,bname] = fileparts(cint);
    %
    %
    if isempty(intitle)
        mtitle = bname;%%[num2str(times(notime+1)) ' yr'];
    else
        if iscell(intitle)
            mtitle = intitle{ni};
        else
            mtitle = intitle;
        end
    end
    %
    info = sim_roirsc(fcrsc);
    %
    if isnan(gmt_mul(ni))
        cgmt_mul = -1.*info.wavelength./(4*pi);
    else
        cgmt_mul = gmt_mul(ni);
    end
    %
    [xoff,yoff,iscon,isov,gmt_snew] = gmt_sortplot(numraw,numcol,ni,xwid,yhigh);
    %
    if ni == nints
        iscon = 0;
    end
    %
    if ~isempty(gmt_xtitle)
        cgmt_xtitle = gmt_xtitle{ni};
    else
        cgmt_xtitle = '';
    end
    if ~isempty(gmt_ytitle)
        cgmt_ytitle = gmt_ytitle{ni};
    else
        cgmt_ytitle = '';
    end
    if ~isempty(gmt_xoff)
        if ni == 1
            xoff = gmt_xoff;
        end
        %
    end
    if ~isempty(gmt_yoff)
        if ni == 1
            yoff = gmt_yoff;
        end
        %
    end
    %
    if ~isempty(gmt_superisov)
        if ni == 1
            isov = gmt_superisov;
        end
    end
    if ~isempty(gmt_supersnew)
        if ni == 1
            gmt_snew = gmt_supersnew;
        end
    end
    if ~isempty(gmt_constantsnew)
        gmt_snew = gmt_constantsnew;
    end
    %
    if strcmpi(gmt_projtype,'X')
        gmt_proj = [' -J',gmt_projtype,num2str(xwid),'i/',num2str(xwid.*scale),'i'];
    else
        gmt_proj = [' -J',gmt_projtype,num2str(xwid),'i'];
    end
    if numel(gmt_minwrap) < ni
        gmt_minwrap(ni) = gmt_minwrap(1);
    end
    if numel(gmt_maxwrap) < ni
        gmt_maxwrap(ni) = gmt_maxwrap(1);
    end
    if numel(gmt_zinterv) < ni
       gmt_zinterv(ni) = gmt_zinterv(1);
    end
    %
    %
    outregion = gmt_img2ps(fcint,....
        'gmt_xoff',                       xoff,...
        'gmt_scale',                      gmt_scale,...
        'gmt_demgrd',                     gmt_demgrd,...
        'gmt_yoff',                       yoff,...
        'gmt_psscale_background_pen',     gmt_psscale_background_pen,...
        'gmt_psscale_background_fill',    gmt_psscale_background_fill,...
        'gmt_psscale_background_offset',  gmt_psscale_background_offset,...
        'gmt_psscale_background_offset_t',gmt_psscale_background_offset_t,...
        'gmt_psscale_background_offset_b',gmt_psscale_background_offset_b,...
        'gmt_psscale_background_offset_l',gmt_psscale_background_offset_l,...
        'gmt_psscale_background_offset_r',gmt_psscale_background_offset_r,...
        'gmt_proj',                       gmt_proj,...
        'gmt_outps',                      gmt_outps,....
        'gmt_iscon',                      1,...
        'gmt_isov',                       isov,...
        'gmt_xtitle',                     cgmt_xtitle,...
        'gmt_ytitle',                     cgmt_ytitle,....
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
        'minwrap',                        minwrap,...
        'maxwrap',                        maxwrap,...
        'gmt_minwrap',                    gmt_minwrap(ni),...
        'gmt_maxwrap',                    gmt_maxwrap(ni),...
        'gmt_colorbarxoffset',            gmt_colorbarxoffset,...
        'gmt_colorbaryoffset',            gmt_colorbaryoffset,...
        'gmt_colorbarwidth',              '0.07i',...
        'gmt_colorbarlength',             '0.6i',...
        'gmt_outdpi',                     gmt_outdpi,...
        'gmt_zinterv',                    gmt_zinterv(ni),...
        'gmt_unit',                       gmt_unit,...
        'gmt_mul',                        cgmt_mul,...
        'gmt_version',                    gmt_version);
    %
    gmt_psxy4line(faulttopo,...
        'outps',gmt_outps,...
        'gmt_faultstype',gmt_faultstype,...)
        'isov',1,...
        'iscon',1,...
        'proj',' -J ',...
        'gmt_lwid',gmt_faulttopwid,...
        'linecolor',',255/10/10',...
        'mregion',' -R ');
    %
    gmt_psxy4line(faultpoly,...
        'outps',gmt_outps,...
        'gmt_faultstype',' ',...)
        'isov',1,...
        'iscon',1,...
        'proj',' -J ',...
        'gmt_lwid',gmt_faultlinewid,...
        'linecolor','',...
        'mregion',' -R ');
    %
    if ~isempty(gmt_profile)
        x      = gmt_profile.x;
        y      = gmt_profile.y;
        stitle = gmt_profile.titles{1};
        etitle = gmt_profile.titles{2};
        buffer = gmt_profile.bufferwidth;
        gmt_plotprofile(x,y,stitle,etitle,gmt_outps,...
            'fontsize',      gmt_profilefontsize,....
            'shiftdist',     gmt_profilelableshift,...
            'gmt_fontcolor', gmt_profilefontcolor,...
            'bufferwidth',buffer);
    end
    % 
    % Updated by Feng, W.P., @ YJ, 2015-05-17
    %
    if ni == nints
        %
        if isempty(gmt_superiscon)
            ciscon = iscon;
        else
            ciscon = gmt_superiscon;
        end
    else
        ciscon = iscon;
    end
    %
    %
    if gmt_istrackinfo==1
        vlon = outregion(1)+gmt_trackxscale*(outregion(2)-outregion(1));
        vlat = outregion(3)+gmt_trackyscale*(outregion(4)-outregion(3));
        azi  = info.heading_deg;
        gmt_sartrackinfo(vlon,vlat,azi,gmt_outps,...
            'gmt_lengthscale',gmt_trackinfolengthscale);%,varargin)
    end
    gmt_pstext(...
        'text_x',         num2str(outregion(1)+(outregion(2)-outregion(1))*gmt_titlexoffset),...
        'text_y',         num2str(outregion(4)-(outregion(4)-outregion(3))*gmt_titleyoffset(ni)),...
        'text_string',    mtitle,...
        'text_isov',      1,...
        'text_size',      text_size,...
        'text_edgewidth', text_edgewidth,...
        'text_iscon',     ciscon,...
        'text_backcolor', text_backcolor,...
        'text_fontcolor', text_fontcolor,...
        'text_pen',       text_pen,...
        'text_fillcolor', text_fillcolor,...
        'text_relativeloc',text_relativeloc,...
        'gmt_outdpi',     gmt_outdpi,...
        'text_outps',     gmt_outps,...
        'gmt_version',    gmt_version);
    if  iscon == 0
        return;
    end
end
%