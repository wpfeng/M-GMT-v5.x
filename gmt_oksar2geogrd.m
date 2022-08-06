function gmt_oksar2geogrd(oksars,outfile,uzone,grdthresh)
%
%
% Map slip model onto a geographical background image...
% by FWP, @ Vienna, 2013-04-08
%
%oksars    = '../oksar/grace_inv_cgls.oksar';
%
if nargin < 1
    disp(gmt_oksar2geogrd(oksars,outfile));
    return
end
%
if nargin < 2
    outfile = 'xyz.grd';
end
%
gmt_resample = 0.05;
gmt_xsize    = 20/110*1.5;
gmt_ysize    = 20/110*1.5;
gmt_method   = 'b';
%
fpara     = sim_oksar2SIM(oksars);
%
zone      = sim_oksar2utm(oksars);
if isempty(zone)
    if nargin >= 4 && isempty(uzone)==0
       zone = uzone;
    else
       disp(' Please specify the utm-zone');
       return
    end
end
ilrs      = sim_fpara2sortv2(fpara);
%
[lat,lon] = utm2deg(fpara(:,1).* 1000,fpara(:,2).*1000,zone);
% strike slip component
xyz1      = [ilrs,fpara(:,8)];
xyz1bin   = 'xyz1_strikeslip.bin';
xyzstrslip  = 'xyz1_strikeslip.grd';
gra_outfile(xyz1,'xyz1_strikeslip','binary');
gmt_xyz2grd(xyz1bin,xyzstrslip,...
    'gmt_resample',gmt_resample,...
    'gmt_method',gmt_method,...
    'gmt_isquick',0,...
    'gmt_filetype','binary');
% dip slip component...
xyz2      = [ilrs,fpara(:,9)];
xyz2bin     = 'xyz2_dipslip.bin';
xyzdipslip  = 'xyz2_dipslip.grd';
gra_outfile(xyz2,'xyz2_dipslip','binary');
gmt_xyz2grd(xyz2bin,xyzdipslip,...
    'gmt_resample',gmt_resample,...
    'gmt_isquick',0,...
    'gmt_method',gmt_method,...
    'gmt_filetype','binary');
%
% lon component...
xyz2      = [ilrs,lon];
xyz2bin   = 'xyz2_lon.bin';
xyzlon    = 'xyz2_lon.grd';
gra_outfile(xyz2,'xyz2_lon','binary');
gmt_xyz2grd(xyz2bin,xyzlon,...
    'gmt_resample',gmt_resample,...
    'gmt_method',gmt_method,...
    'gmt_isquick',0,...
    'gmt_filetype','binary');
%
% lat component...
xyz2      = [ilrs,lat];
xyz2bin   = 'xyz2_lat.bin';
xyzlat    = 'xyz2_lat.grd';
gra_outfile(xyz2,'xyz2_lat','binary');
gmt_xyz2grd(xyz2bin,xyzlat,...
    'gmt_resample',gmt_resample,...
    'gmt_method',gmt_method,...
    'gmt_isquick',0,...
    'gmt_filetype','binary');
%
gmt_grd2xyz(xyzlon,'lon.bin');
gmt_grd2xyz(xyzlat,'lat.bin');
gmt_grd2xyz(xyzdipslip,'dip.bin');
gmt_grd2xyz(xyzstrslip,'str.bin');
%
lon = gra_readdata('lon.bin','binary');
lat = gra_readdata('lat.bin','binary');
dip = gra_readdata('dip.bin','binary');
str = gra_readdata('str.bin','binary');
xyz = [lon(:,3),lat(:,3),sqrt(str(:,3).^2+dip(:,3).^2)];
gra_outfile(xyz,'xyz','binary');
gmt_xyz2grd('xyz.bin',outfile,...
    'gmt_resample',0,...
    'gmt_isquick',0,...
    'gmt_method',gmt_method,...
    'gmt_xsize',gmt_xsize,...
    'gmt_ysize',gmt_ysize,...
    'gmt_filetype','binary');