function outname = gmt_overlayoksar(oksar,outname)
%
%
%
% Created by FWP, @ GU, 2013-06-16
%
[~,bname] = fileparts(oksar);
if nargin < 2
    outname = bname;
end
%
%
fpara = sim_oksar2SIM(oksar);
uzone = sim_oksar2utm(oksar);
%
dist         = fpara(:,5);
[~,sind]     = sort(dist);
%
index_1      = find(fpara(:,5) == fpara(sind(1),5));
%
%index_2      = fpara(:,5) ~= fpara(sind(1),5);
%
fid = fopen([outname,'_top.geo'],'w');
for ni = 1:numel(index_1)
    cfpara = fpara(index_1(ni),:);
    %
    rfpara = sim_fpara2rand_UP(cfpara);
    [ix1,iy1] = sim_fpara2corners(rfpara,'ur');%,incoor,outcoor,outzone)
    [ix2,iy2] = sim_fpara2corners(rfpara,'ul');%,incoor,outcoor,outzone)
    topline   = [ix1,iy1;ix2,iy2];
    %
    [lat,lon] = utm2deg(topline(:,1).*1000,topline(:,2).*1000,uzone);
    topline   = [lon(:),lat(:)];
    %
    fprintf(fid,'%s\n','>');
    fprintf(fid,'%s %s\n',topline');
    %
end
fclose(fid);
%
fid = fopen([outname,'_polygons.geo'],'w');
for ni = 1:numel(fpara(:,1))
    rfpara = fpara(ni,:);
    %
    %rfpara = sim_fpara2rand_UP(cfpara);
    [ix1,iy1] = sim_fpara2corners(rfpara,'ur');%,incoor,outcoor,outzone)
    [ix2,iy2] = sim_fpara2corners(rfpara,'ul');%,incoor,outcoor,outzone)
    [ix3,iy3] = sim_fpara2corners(rfpara,'ll');%,incoor,outcoor,outzone)
    [ix4,iy4] = sim_fpara2corners(rfpara,'lr');%,incoor,outcoor,outzone)
    %[ix1,iy1] = sim_fpara2corners(rfpara,'ur');%,incoor,outcoor,outzone)
    topline   = [ix1,iy1;ix2,iy2;ix3,iy3;ix4,iy4;ix1,iy1];
    %
    [lat,lon] = utm2deg(topline(:,1).*1000,topline(:,2).*1000,uzone);
    topline   = [lon(:),lat(:)];
    %
    fprintf(fid,'%s\n','>');
    fprintf(fid,'%s %s\n',topline');
    %
end
fclose(fid);
