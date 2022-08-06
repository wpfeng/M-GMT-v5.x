function gmt_cptname_top = gmt_optimaldipalpha(infile,varargin)
% 
% Write by W.P, Feng, 2011-11-10, @ GU
%
%%

file          = infile;
gmt_iscolorbar = 1;
gmt_xsize     = 0.1;
gmt_colorbarannosize = [];
gmt_ysize     = 0.1;
conzinterv    = 0.1;
gmt_axstep    = '5f5';
gmt_aystep    = '2f2';
gmt_yoff      = '1i';
gmt_xoff      = '1i';
gmt_snew      = 'SnEw';
gmt_outps     = 'Fig_x_optimaldipalpha.ps';
gmt_isov      = 0;
gmt_iscon     = 0;
gmt_resample  = 0.1;
gmt_method    = 'b';
outgrd        = 'bestdipstrike.grd';
gmt_backgroud = ' ';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_proj      = ' -JX3i/2.4i ';
incpt         = 'gray';
cpt_isreverse = 0;
zinterv       = 1.0;
gmt_constart  = -0.5;
gmt_conend    = 0.5;
%%
gmt_cptname_top = 'slip_top.cpt';
gmt_cptname   = 'slip.cpt';
slipytitle    = '@~a@+2';%'Alpha';
slipxtitle    = 'dip(degree)';
cyoffset      = '0.25i';
cxoffset      = '2.3i';
clength       = '0.6i';
cwidth        = '0.025i';
ctitle        = 'Opt';
czinterv      = '1';
cunit         = '';
%% parameters for optimal locations...
%
gmt_psize     = '0.5c';
%%
text_size     = 7;
text_string   = '(b)';
text_fontcolor= '255/255/255';
text_backcolor= '0/0/0';
%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%%
data1 = load(file);
xmin  = floor(min(data1(:,1)));
ymin  = floor(min(data1(:,2)));
xmax  = ceil(max(data1(:,1)));
ymax  = ceil(max(data1(:,2)));
xlen  = xmax - xmin;
ylen  = ymax - ymin;
slippatch  = infile;%
%%
mregion = [' -R',num2str(xmin),'/',num2str(xmax),'/',num2str(ymin),'/',num2str(ymax)];

%
gmt_xyz2grd(slippatch,outgrd,...
    'gmt_xsize',gmt_xsize,...
    'gmt_ysize',gmt_ysize,...
    'gmt_resample',gmt_resample,...
    'gmt_filetype','ascii',...
    'gmt_method',gmt_method,...
    'gmt_isquick',0);
%
xyzgrdstr = ['grd2xyz ',outgrd,'   > xyz.out'];
disp(xyzgrdstr);
system(xyzgrdstr);
xyzdata   = load('xyz.out');
minpoints = xyzdata(xyzdata(:,3)==min(xyzdata(:,3)),:);
%whos minpoints
minpoints = minpoints(1,:);
%
%
zmin = min(data1(:,3))-0.5;
zmax = max(data1(:,3))+0;
gmt_makecpt('gmt_colorn',incpt,'gmt_cptname',gmt_cptname_top,'gmt_logrithm','  ',...
    'gmt_zstart',zmin,'gmt_isreverse',cpt_isreverse,...
    'gmt_zend',zmax,'gmt_zinterv',zinterv,'gmt_iscontin',1)
gmt_grdimage(outgrd,...
    'gmt_isov',gmt_isov,...
    'gmt_iscon',1,...
    'gmt_colorbarannosize',gmt_colorbarannosize,...
    'gmt_proj',gmt_proj,...
    'gmt_mregion',mregion,...
    'gmt_outps',gmt_outps,...
    'gmt_zinterv',czinterv,...
    'gmt_axstep',gmt_axstep,...
    'gmt_yoff',gmt_yoff,...
    'gmt_xoff',gmt_xoff,...
    'gmt_xtitle',slipxtitle,...
    'gmt_ytitle',slipytitle,...
    'gmt_aystep',gmt_aystep,...
    'gmt_colorbarwidth',cwidth,...
    'gmt_snew',gmt_snew,...
    'gmt_unit',cunit,...
    'gmt_iscolorbar',gmt_iscolorbar,...
    'gmt_colorbarxoffset',cxoffset,...
    'gmt_colorbaryoffset',cyoffset,...
    'gmt_unit',ctitle,...gmt_unit
    'gmt_colorbarlength',clength,...
    'gmt_cptname',gmt_cptname_top,...
    'gmt_backgroud',gmt_backgroud);
%
% 
gmt_makecpt('gmt_colorn',incpt,'gmt_cptname',gmt_cptname,'gmt_logrithm','  ',...
    'gmt_zstart',gmt_constart,'gmt_isreverse',cpt_isreverse,...
    'gmt_zend',gmt_conend,'gmt_zinterv',conzinterv,'gmt_iscontin',1)
%
% pscontour
gmt_grdcontour(outgrd,...
    'gmt_outps',gmt_outps,...
    'gmt_cptname',gmt_cptname,...
    'gmt_proj',gmt_proj,...
    'gmt_mregion',mregion,...
    'gmt_iscon',1,...
    'gmt_conlw','2p',...
    'gmt_concol','/150/150/150,-',...
    'gmt_lables','5');
%
gmt_makecpt('gmt_colorn',incpt,'gmt_cptname',gmt_cptname,'gmt_logrithm','  ',...
    'gmt_zstart',-1.4,'gmt_isreverse',cpt_isreverse,...
    'gmt_zend',-1.3,'gmt_zinterv','0.05','gmt_iscontin',1);
%
gmt_grdcontour(outgrd,...
    'gmt_outps',gmt_outps,...
    'gmt_cptname',gmt_cptname,...
    'gmt_proj',gmt_proj,...
    'gmt_mregion',mregion,...
    'gmt_iscon',1,...
    'gmt_conlw','2p',...
    'gmt_concol','/150/150/150,-',...
    'gmt_lables','5');
%%%%%%%%%%%%%%%%%
%
%disp([' optDIP&ALPHA: ',num2str(minpoints(:,1:2))]);
gmt_psxy4points(minpoints(:,1:2),...
    'gmt_isov',1,...
    'gmt_iscon',1,...
    'gmt_outps',gmt_outps,...
    'gmt_psize',gmt_psize,...     %);
    'gmt_snew','',...
    'gmt_pfillc','255/255/255',...
    'gmt_ptype','a',...
    'gmt_linecolor','/0/0/0');
gmt_pstext(...
    'text_x',num2str(xmin+xlen*0.005),...
    'text_y',num2str(ymax-ylen*0.065),...
    'text_string',text_string,...
    'text_outps',gmt_outps,...
    'text_fontcolor',text_fontcolor,...
    'text_backcolor',text_backcolor,...
    'text_iscon',gmt_iscon,...
    'text_size',text_size);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return