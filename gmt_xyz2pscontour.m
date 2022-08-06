function gmt_xyz2pscontour(xyzfile,varargin)
%
%
%
%
% created by Feng, W.P., 2011-10-30, @ GU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
gmt_cptname = '';
gmt_mregion = ' -R ';
gmt_proj    = ' -J ';
gmt_isov    = 1;
gmt_iscon   = 1;
gmt_outps   = 'test.ps';
gmt_conlw   = '0.8p';
gmt_concol  = ',0/0/255';
gmt_contype = '';
gmt_xoff    = '0i';
gmt_yoff    = '0i';
gmt_axstep  = '';
gmt_aystep  = '';
gmt_lables  = '12';
gmt_labelcolor = '255/0/0';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Updated by Feng, W.P., @ BJ, 2015-07-22
%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
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
type      = [type2,' ',type1];
%
if ischar(xyzfile)
    xyz = load(xyzfile);
    gra_outfile(xyz,'xyz.inp','ascii');
    outfilename = xyzfile;
else
    gra_outfile(xyzfile,'xyz.inp','ascii');
    outfilename = 'xyz.inp.ascii';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if isempty(gmt_axstep)
    gmt_btype =  ' -B ';
else
    gmt_btype = [ ' -B',gmt_axstep,'/',gmt_aystep,' '];
end
%
pscontourstr = ['pscontour  ',outfilename,' ',gmt_mregion,...
    ' -A+k' gmt_labelcolor,' ',...
    gmt_proj '-A+s' gmt_lables,...
    ' -C' gmt_cptname,...
    ' -X',gmt_xoff,' ',...
    ' -Y' gmt_yoff,' ',gmt_btype,...
    ' -W' gmt_conlw,gmt_concol,gmt_contype,...
    ' ',type,gmt_outps];
%
disp(pscontourstr);
system(pscontourstr);
if gmt_iscon == 0
   ps2ras = ['gmt psconvert ' gmt_outps ' -Tj -A -E720'];
   disp(ps2ras);
   system(ps2ras);
   ps2ras = ['gmt psconvert ' gmt_outps ' -Tf -A -E300'];
   disp(ps2ras);
   system(ps2ras);
end
