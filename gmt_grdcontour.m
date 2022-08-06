function gmt_grdcontour(xyzfile,varargin)
%
%
%
%
% created by Feng, W.P., 2011-10-30, @UoG
% Updated by FEng, W.P., @NRCan, 2015-10-09
% -> make it work for GMT5.x in Linux
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
gmt_cptname     = '';
gmt_mregion     = ' -R ';
gmt_sliplow     = [];
gmt_sliphigh    = [];
gmt_slipinterv  = 0.5;
gmt_labelinterv = '0.5';
gmt_proj        = ' -J ';
gmt_isov        = 1;
gmt_iscon       = 1;
gmt_outps       = 'test.ps';
gmt_contype     = '';
gmt_conlw       = '1p';
gmt_concol      = ',0/0/0';
gmt_xoff        = '0i';
gmt_yoff        = '0i';
gmt_axstep      = '';
gmt_aystep      = '';
gmt_labelsize   = '5';
gmt_labelback   = [];%'255/255/255';
gmt_contourfile = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%
type1 = '>';
if gmt_isov==1
   type1 = ' -O >>';
end
type2 = ' -K ';
if gmt_iscon==0
    type2 = '';
end
type = [type2,' ',type1];
%
%[~,bname] = fileparts(xyzfile);
%gmt_contourfile = [bname,'.contour.xyz'];
if isempty(gmt_contourfile)~=1
    gmt_contourfile = [' -D',gmt_contourfile,' '];
else
    gmt_contourfile = '';
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if ~isempty(gmt_slipinterv)
    ctype = [' -C',num2str(gmt_slipinterv)];
else
    ctype = [' -C',gmt_cptname];
end
if ~isempty(gmt_sliplow) && ~isempty(gmt_sliphigh)
    limittype = [' -L',num2str(gmt_sliplow),'/',num2str(gmt_sliphigh)];
else
    limittype = '';
end
if ~isempty(gmt_axstep) && ~isempty(gmt_aystep)
    btype = [' -B',gmt_axstep,'/',gmt_aystep];
else
    btype = '';
end
%
if ~isempty(gmt_labelback)
    labelback = ['+g',gmt_labelback];
else
    labelback = '';
end
%
pscontourstr = ['gmt grdcontour ' xyzfile, '  ' gmt_mregion ' -A',gmt_labelinterv,'+f',gmt_labelsize,...
    labelback,' ', gmt_proj,ctype,' -X',gmt_xoff,' ',...
    ' -Y' gmt_yoff,limittype,btype,...' -B',gmt_axstep,'/',gmt_aystep,...
    ' -W' gmt_conlw,gmt_concol,gmt_contype,gmt_contourfile,type,gmt_outps];
disp(pscontourstr);
system(pscontourstr);
if gmt_iscon == 0
   ps2ras = ['gmt ps2raster ' gmt_outps ' -Tf -A -E300'];
   system(ps2ras);
end
