function gmt_xyz2grd(xyzfile,outfile,varargin)
%
%
% One of the m-script collections for assiting GMT commands to plot
% high-resolution figures...
%
% Create by Feng,W.P., @ UoG, 2012-08-08
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_xsize    = [];
gmt_ysize    = [];
gmt_mregion  = [];
gmt_color    = gmt_cptdb('Fire-2');%'seis';
gmt_axstep   = '1';
gmt_aystep   = '1';
gmt_isquick  = 1;
gmt_resample = 0;
gmt_filetype ='ascii';
gmt_method   = 'b';
gmt_isfilter = 0;
gmt_proj     = '-JX4i';
gmt_sample   = 0;
gmt_ytitle   = 'Y';
gmt_xtitle   = 'X';
gmt_unit     = 'Scalar';
gmt_zinterv  = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni =1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
    %
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gmt_resample
%
%
switch upper(gmt_filetype);
    case 'ASCII'
        data = load(xyzfile);
        gmt_xyz2grdtype = ' ';
    case 'BINARY'
        %
        fid = fopen(xyzfile,'r');
        data = fread(fid,[3,inf],'float');
        fclose(fid);
        %
        data = data';
        gmt_xyz2grdtype = ' -bi3f ';
        %gmt_outputtype = '-bos';
    otherwise
        data    = xyzfile;
        xyzfile = 'test.bin';
        fid     = fopen(xyzfile,'w');
        fwrite(fid,data','float');
        fclose(fid);
        gmt_xyz2grdtype = ' -bi3f ';
        %
end
%
if nargin < 2 || isempty(outfile) 
   [bdir,bname] = fileparts(xyzfile);
   outfile      = fullfile(bdir,[bname,'.grd']);
end
%
%mindist   = sim_mindistv2(data(:,1:2))
if isempty(gmt_xsize) || isempty(gmt_ysize)
    %
    mindist   = sim_mindistv2(data(:,1:2));
    gmt_xsize = mindist;
    gmt_ysize = mindist;
end
if isempty(gmt_mregion)
    minlon    = min(data(:,1));
    maxlon    = max(data(:,1));
    minlat    = min(data(:,2));
    maxlat    = max(data(:,2));
    gmt_mregion = [' -R',num2str(minlon),'/',num2str(maxlon),'/',num2str(minlat),'/',num2str(maxlat),' '];
end
%
%blockmedian $ifile -R$region -I$int -V > $blkfile
if gmt_isfilter == 1
    %
    surfacestr = ['gmt surface ',xyzfile,gmt_mregion,' -T0.05 -G',outfile,' ', gmt_xyz2grdtype,' -C0.01 -I',num2str(gmt_xsize),'/',num2str(gmt_ysize)];
    disp(surfacestr);
    system(surfacestr);
    %
else
    xyzgrdstr = ['gmt xyz2grd  ',xyzfile, ' ',gmt_mregion,'  -G',outfile,' ', gmt_xyz2grdtype,'  -I',num2str(gmt_xsize),'/',num2str(gmt_ysize)];
    disp(xyzgrdstr);
    system(xyzgrdstr);
end
%
if gmt_sample == 1
    %
    movefile(outfile,'tmptt.grd');
    gmt_grdsample('tmptt.grd',...
        'gmt_method','b',...
        'gmt_incscale',0.125,...
        'gmt_ggrd',outfile);
end
%
if gmt_resample ~= 0
    gmt_grdsample(outfile,...
        'gmt_ggrd',outfile,...
        'gmt_incscale',gmt_resample,...
        'gmt_method',gmt_method);
end
%
%
if gmt_isquick ~=0
   gmt_grdimagev2(outfile,...
       'gmt_proj',   gmt_proj,...
       'gmt_ytitle', gmt_ytitle,...
       'gmt_xtitle', gmt_xtitle,...
       'gmt_colorn', gmt_color,...
       'gmt_unit',   gmt_unit,...
       'gmt_zinterv',gmt_zinterv,...
       'gmt_iscon',  0,...
       'gmt_axstep', gmt_axstep,...
       'gmt_aystep', gmt_aystep,...
       'gmt_outps', [outfile,'.ps']);
   
   %
%    [bx,by] = gmt_grdbounds(outfile);
%    [x,y,z] = gmt_grdminmax(outfile);
%    p1      = [x(1),by(1);x(1),by(2)];
%    p2      = [bx(1),y(1);bx(2),y(1)];
%    %
%    gmt_psxy4line(p1,...
%        'outps',         [outfile,'.ps'],...
%        'gmt_faultstype',' ',...)
%        'isov',          1,...
%        'iscon',         1,...
%        'proj',          ' -J ',...
%        'gmt_lwid',     '0.1c,255/255/255,--',...
%        'linecolor',    '',...
%        'mregion',      ' -R ');
%    gmt_psxy4line(p2,...
%        'outps',         [outfile,'.ps'],...
%        'gmt_faultstype',' ',...)
%        'isov',          1,...
%        'iscon',         1,...
%        'proj',          ' -J ',...
%        'gmt_lwid',     '0.1c,255/255/255,--',...
%        'linecolor',    '',...
%        'mregion',      ' -R ');
%    gmt_psxy4points([x(1),y(1)],...
%             'gmt_outps',    [outfile,'.ps'],...
%             'gmt_proj',     ' -J ',...
%             'gmt_isov',     1,...
%             'gmt_iscon',    1,...
%             'gmt_ptype',    'a',...
%             'gmt_psize',    '0.5c',...
%             'gmt_lwid',     '0.05c');
%    gmt_makecpt('gmt_colorn','gray',...
%        'gmt_cptname','grd.cpt','gmt_logrithm','  ',...
%        'gmt_zstart', '0',...
%         'gmt_zend',   '1',...
%         'gmt_zinterv','0.01',...
%         'gmt_iscontin',1);
%     %
%     gmt_grdcontour(outfile,...
%         'gmt_isov',       1,...
%         'gmt_cptname',    'grd.cpt',... 
%         'gmt_conlw',      '0.5p',...0
%         'gmt_iscon',      0,...
%         'gmt_lables',     '4p',...
%         'gmt_slipinterv', '0.01',...
%         'gmt_outps',  [outfile,'.ps']);
end