function sar_cutbyroi_givespatial_dir(roi,postfix,pixelsize,searchpost)
%
%
%
% Developed by FWP, @GU, 2014-05-01
%
%
if nargin < 2
    postfix = 'ROI';
end
if nargin < 3
    pixelsize = [0.00083333,0.00083333];
end
if nargin < 4
    searchpost = 'mst*.phs';
end
%
cphs = dir(['geo*',searchpost]);%mst*.phs');
if numel(cphs)<0
    %
    disp([pwd,' no corrected PHS available']);
    return
end
%
cphs = cphs(1).name;
%
gmt_img2grd_fixspatialsize(cphs,'T.grd',roi,'float',pixelsize);%,iswrap,minwrap,maxwrap,scale,opvalue)
%
rscfile = [cphs,'.rsc'];
masterdate = rscfile(5:12);
slavedate  = rscfile(14:21);
sartrack   = rscfile(23:26);
outphs     = ['geo-',masterdate,'-',slavedate,'-',sartrack,'-',postfix,'.phs'];
gmt_grd2roi('T.grd',outphs,'f',rscfile);
%
% Replace Nan by 0
[data,~,~,info] = sim_defreadroi(outphs,'float',1,0);
data(isnan(data)) = 0;
sim_roi2ENVI(data,info,outphs,postfix);
%