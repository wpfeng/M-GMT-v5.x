function geo_oksar2grd(oksar,varargin)
%
%
% oksar = '../oksar/turkey_dist_asarandcskv2.oksar';
% Created by FWP, @ UoG, 2012-10-26
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold        = 0.05;
gmt_xsize        = 0.02;
gmt_ysize        = 0.02;
oksarimg         = [];
gmt_isquick      = 0;
gmt_isoversample = 0;
gmt_outoksar     = [];
gmt_isfilter     = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
if gmt_isoversample~=0
    %
    if isempty(gmt_outoksar);
        gmt_outoksar  = '_tmp.oksar';
    end
    %
    if ~exist(gmt_outoksar,'file')
        iteration = 100;
        thre      = 5;
        fpara    = sim_oksar2SIM(oksar);
        zone     = sim_oksar2utm(oksar);
        outfpara = sim_fpara2oversamplebyscale(fpara,thre);
        sim_fpara2oksar(outfpara,gmt_outoksar,zone);
        %sim_oksar2oversamplebyscale(oksar,gmt_outoksar,iteration,thre)
    end
end
fpara = sim_oksar2SIM(oksar);
uzone = sim_oksar2utm(oksar);
%
[lat,lon] = utm2deg(fpara(:,1).*1000,fpara(:,2).*1000,uzone);
z         = sqrt(fpara(:,8).^2+fpara(:,9).^2);
%
[bdir,bname] = fileparts(oksar);
if isempty(oksarimg)
    %
    oksarimg    = [bname,'.Img'];
    %
end
outxyz    = fullfile(bdir,[bname,'.llz']);
oksargrd  = fullfile(bdir,[bname,'.grd']);
%
xyz       = [lon,lat,z];
gra_outfile(xyz,outxyz,'binary');
%
gmt_xyz2grd([outxyz,'.bin'],oksargrd,...
    'gmt_xsize',    gmt_xsize,...
    'gmt_ysize',    gmt_ysize,...
    'gmt_resample', 0.1,...
    'gmt_method',   'b',...
    'gmt_isfilter', gmt_isfilter,...
    'gmt_isquick',  gmt_isquick,...
    'gmt_filetype', 'binary');
%
gmt_grdmath(oksargrd,threshold,'GE','flag.grd');
gmt_grdmath(oksargrd,'flag.grd','MUL',oksargrd);
%
gmt_grd2roi(oksargrd,oksarimg,'f');