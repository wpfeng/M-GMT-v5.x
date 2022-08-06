function batch_image_plot(prefix_images,gmt_outps,rootdir,ctitles,varargin)
% Created by Feng, W.P., @ GU, 20120825
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    %prefix_images = '*.img.rsc';
    disp('batch_image_plot(prefix_images,gmt_outps,rootdir,varargin);');
    disp('    -> parameters supported in varargin:');
    disp('       "numraw", default is 5');
    disp('       "numcol", default is 4');
    disp('       "maxv",   default is  3.141');
    disp('       "minv",   default is -3.141');
    disp('       "interv", default is  3.14');
    disp('       "xwid",   default is  4');
    disp('       "xwidth", default is  xwid + 0.121');
    disp('       "yhigh",  default is  (xwidth*1.21)');
    disp('       "gmt_iswrap",  default is 1');
    disp('       "gmt_cptname", default is velocity_power.cpt');
    disp('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    disp('***** Created by Feng, W.P., @ GU, 2012-08-26 *****');
    disp('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    %
    return
end
if nargin < 2
    %
    gmt_outps = 'velocity_power.ps';
end
%
if nargin < 3
    rootdir = './';
end
if nargin < 4
    ctitles = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numraw       = 3;
numcol       = 4;
interv       =  3.14;
minv         = -3.141;
maxv         =  3.141;
min_wrapsize = -3.14;
max_wrapsize =  3.14;
xwidth       = [];
yhigh        = [];
type         = 'prefix';
%
gmt_outdpi    = 120;
gmt_demgrd    = [];
gmt_zerovalue = [];
gmt_cptname   = [];
gmt_nanvalue  = [];
gmt_factor    = [];
gmt_cmconv    = 0;
gmt_version   = 5;
gmt_demgrd    = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xwid        = 4;
gmt_iswrap  = 1;
%gmt_cptname = 'velocity_power.cpt';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%
if isnumeric(gmt_outdpi)
    gmt_outdpi = num2str(gmt_outdpi);
end
%
cxwidth = xwid + 0.15;

if isempty(xwidth)
    xwidth = cxwidth;
end
cyhigh  = xwidth*1.121;
if isempty(yhigh)
    yhigh = cyhigh;
end
%cyhigh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(type,'prefix')
   ints = dir([rootdir,prefix_images]);
else
   ints = prefix_images;
end
%
gmt_gmtset('gmt_paper_media','A0');
%
if ~exist(gmt_cptname,'file')
    gmt_cptname = '_tmp.cpt';
    gmt_makecpt('gmt_zstart',minv,'gmt_zend',maxv,...
        'gmt_cptname',gmt_cptname);
end
%
for ni = 1:numel(ints)
    %
    if strcmpi(type,'prefix');
        cint  = ints(ni).name;
        fcrsc = [rootdir,cint];
        [~,rootname] = fileparts(cint);
        [~,times]    = fileparts(rootname);
        fcint        = [rootdir,rootname];
        mtitle       = times;
    else
        cint  = ints{ni};
        fcrsc = [cint,'.rsc'];
        fcint = cint;
        
    end
    if ~isempty(ctitles)
        mtitle = ctitles{ni};
    end
    %
    
    %
    info         = sim_roirsc(fcrsc);
    [xoff,yoff,iscon,isov,gmt_snew] = gmt_sortplot(numraw,numcol,ni,xwidth,yhigh);
    
    %disp(yoff);
    if ni == numel(ints)
        iscon = 0;
    end
    %
    if gmt_cmconv == 1
       gmt_factor = info.wavelength/(4*pi)*100;
    end
    %
    gmt_img2ps(fcint,....
        'gmt_xoff',xoff,...
        'gmt_demgrd',gmt_demgrd,...
        'gmt_yoff',yoff,...
        'gmt_proj',[' -JM',num2str(xwid),'i'],...
        'gmt_outps',gmt_outps,....
        'gmt_demgrd',gmt_demgrd,...
        'gmt_iscon',1,...
        'gmt_isov',isov,...
        'gmt_nanvalue',gmt_nanvalue,...
        'gmt_snew',gmt_snew,...
        'iswrap',gmt_iswrap,...
        'gmt_cptname',[],...
        'minwrap',min_wrapsize,...
        'maxwrap',max_wrapsize,...
        'gmt_colorbarxoffset','0.8i',...
        'gmt_colorbaryoffset','0.45i',...
        'gmt_colorbarwidth','0.1i',...
        'gmt_colorbarlength','1i',...
        'gmt_outdpi',gmt_outdpi,...
        'gmt_zinterv',interv,...
        'gmt_zerovalue',gmt_zerovalue,...
        'gmt_factor',gmt_factor,...
        'gmt_version',gmt_version);
    %
    gmt_pstext(...
        'text_x',num2str(info.x_first+0.025),...
        'text_y',num2str(info.y_first-0.05),...
        'text_string',mtitle,...
        'text_isov',1,...
        'text_iscon',iscon,...
        'gmt_outdpi',gmt_outdpi,...
        'text_outps',gmt_outps,...
        'gmt_version',gmt_version);
    if  iscon == 0
        return;
    end
end