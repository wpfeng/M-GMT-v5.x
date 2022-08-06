function gmt_geoslipondem(varargin)
%
%  Developed by FEng, w.p., @ NRCan, 2015-10-08
%

gmt_outps        = 'Figure_RS2_slipmodel_v151007.ps';
sliptile         = '';
zone             = '19H';
eventtitle       = 'ChileMw8.3';
maxslip          = 60;
demfile          = sar_dempath('ETOPO1');
sliptype         = 'Slip';
gmt_stressunit   = 'Slip(m)';
gmt_snew         = 'SNEW';
gmt_frictioncoef = 0.4;
gmt_slipinterval = '20';
gmt_transparency = '30';
gmt_iscon        = 0;
gmt_isov         = 0;
gmt_xoff         = '4i';
gmt_yoff         = '4i';
gmt_proj         = ' -JM4i ';
gmtepi           = [-71.65,-31.57];
roi              = [-73,-71,-32.5,-30.25];
gmt_oksar        = 'Chile_RS2_dist_v151006.simp';
gmt_colordir     = 'h';
gmt_xshift       = '3i';
gmt_yshift       = '0.55i';
gmt_xlength      = '0.855i';
gmt_ywidth       = '0.085i';
gmt_bottomshift  = '0.065i';
%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempdem        = 'tmp.img';
%
sar_cutroi(demfile,tempdem,roi,1,'integer');%,outband)
%
%
gmt_gmtset('gmt_label_font_size',        '8p',...
    'gmt_paper_media','A0',...
    'gmt_annot_font_size_primary','8p',...
    'gmt_label_offset','0.005c');
%
gmt_img2ps(tempdem,...
    'gmt_proj',   gmt_proj,...
    'gmt_demgrd',  tempdem,....
    'gmt_cptname','globe',...
    'gmt_snew',gmt_snew,...
    'gmt_minwrap',-8000,....
    'gmt_maxwrap', 8000,...
    'gmt_inputformat','integer',...
    'gmt_iscolorbar', 0,...
    'gmt_isov',gmt_isov,...
    'gmt_axstep','1',...
    'gmt_aystep','1.5',...
    'gmt_iscon',1,...
    'gmt_xoff',gmt_xoff,...
    'gmt_yoff',gmt_yoff,...
    'isrwap',0,...
    'gmt_demfile',tempdem,...
    'gmt_outps',gmt_outps,...
    'gmt_isov',gmt_isov,'gmt_iscon',1);
%
%
gmt_inpolygons = gmt_oksar2geopolygon(gmt_oksar,zone,1,...
    'frictioncoef', gmt_frictioncoef,...
    'sliptype',     sliptype);

%
slipcpt       = gmt_cptdb('blue');
colormapt     = gmt_importcpt(slipcpt);
backgroundcol = fix(colormapt(2,:).*255);
foregroundcol = fix(colormapt(end-1,:).*255);
gmt_gmtset(...
    'gmt_color_background', [num2str(backgroundcol(1)),'/',...
    num2str(backgroundcol(2)),'/',...);
    num2str(backgroundcol(3))],...
    'gmt_color_foreground', [num2str(foregroundcol(1)),'/',...
    num2str(foregroundcol(2)),'/',...);
    num2str(foregroundcol(3))]);
gmt_makecpt(...
    'gmt_colorn',   gmt_cptdb('slipmodel'),...
    'gmt_zstart',   0,...
    'gmt_zend',     maxslip,...
    'gmt_isreverse',1,...
    'gmt_zinterv',  maxslip./50,....
    'gmt_cptname',  'polygon_slipgeo_chk.cpt');
%
gmt_psxy4polygon(gmt_inpolygons,...
    'gmt_outps',        gmt_outps,...
    'gmt_transparency', gmt_transparency,...
    'gmt_linewide',     '0.08c,200/200/200 ',...
    'gmt_cptname',      'polygon_slipgeo_chk.cpt');
%
system(['gmt psscale -Cpolygon_slipgeo_chk.cpt',' -D',gmt_xshift,'/',gmt_yshift,'',...
    '/',gmt_xlength,'/',gmt_ywidth,gmt_colordir,' ',...
    '-Tp+0.03i+g220/220/220+l0.0850i+r0.0350i+t0.0250i+b',gmt_bottomshift,'',' ',...
    '-B',gmt_slipinterval,':"',sliptile,'":/:"',gmt_stressunit,'":  -K  -O   -E  >>',...
    gmt_outps]);
%
gmt_psxy4points(gmtepi,...
    'gmt_outps',    gmt_outps,...
    'gmt_proj',     ' -J ',...
    'gmt_isov',     1,...
    'gmt_iscon',    1,...
    'gmt_ptype',    'a',...
    'gmt_pfillc',   '255/0/0',...
    'gmt_linecolor',',0/0/0',...
    'gmt_psize',    '0.45c',...
    'gmt_lwid',     '0.02c');
%
gmt_pstext(...
    'text_x',         num2str(gmtepi(1) + 0.05),...
    'text_y',         num2str(gmtepi(2) + 0.05),...
    'text_string',    eventtitle,...
    'text_isov',      1,...
    'text_fontno',    '5',...
    'text_size',      '13p',...
    'text_edgewidth', '',...
    'text_iscon',     gmt_iscon,...
    'text_backcolor', '',...
    'text_fontcolor', 'black,-=0.05p,white',...
    'text_fillcolor', '',...
    'text_outps',     gmt_outps);
%
%
