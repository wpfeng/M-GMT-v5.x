function outphs = sar_cutbyroi_givespatial(cphs,roi,postfix,pixelsize,fulloutname)
%
%
%
% Developed by FWP, @GU, 2014-05-01
% a individual version for image file...
%
if nargin < 2 || isempty(roi)
    roi = sar_rsc2roi([cphs,'.rsc']);
    roi = roi(1:4);
end
%
if nargin < 3 || isempty(postfix)
    postfix = 'ROI';
end
if nargin < 4
    pixelsize = [0.00083333,0.00083333];
end
if nargin < 5
    fulloutname = [];
end
%
%
gmt_img2grd_fixspatialsize(cphs,'T.grd',roi,'float',pixelsize);%,iswrap,minwrap,maxwrap,scale,opvalue)
%
rscfile = [cphs,'.rsc'];
%
[~,bname] = fileparts(rscfile);
%
%
if isempty(fulloutname)
    masterdate = bname(5:12);
    slavedate  = bname(14:21);
    sartrack   = bname(23:26);
    outphs     = ['geo-',masterdate,'-',slavedate,'-',sartrack,'-',postfix,'.phs'];
else
    outphs = fulloutname;
end
%
gmt_grd2roi('T.grd',outphs,'f',rscfile);
%
% Replace Nan by 0
[data,~,~,info] = sim_defreadroi(outphs,'float',1,0);
data(isnan(data)) = 0;
sim_roi2ENVI(data,info,outphs,postfix);
%