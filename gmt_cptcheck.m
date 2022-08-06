function gmt_cptcheck(cptname)
%
%
% Created by FWP, @ GU, 2012-11-25
% check CPT, make a quick figure for cpt file...
%
%
%lons   = [100,110];
%lats   = [35,35.8];
outimg = 'test_cpt.img'; 
cptout = 'tmp_cpt.cpt';
[bdir,bname] = fileparts(cptname);
cptps        = fullfile(bdir,[bname,'.ps']);
%
%
width = 100;
data  = zeros(10,width);
for ni = 1:width
    data(:,ni) = ni/width;
end
info = sim_roirsc();
info.x_step  = 0.05;
info.y_step  = -0.05;
info.x_first = 100;
info.y_first = 35;
info.width   = width;
info.file_length = 10;
%
sim_roi2ENVI(data,info,outimg);
%
gmt_makecpt(...
    'gmt_colorn',cptname,...
    'gmt_cptname',cptout);
%
gmt_gmtset('gmt_basemap_type','plain',...
    'gmt_frame_width','0.01c');
%
gmt_img2ps(outimg,...
    'wrap',0,...
    'gmt_proj','-JM2i',...
    'gmt_cptname',[],...
    'gmt_colorn',cptout,...
    'gmt_iscolorbar',0,...
    'gmt_snew','',...
    'gmt_axstep','1000',...
    'gmt_aystep','1000',...
    'gmt_outps',cptps);
delete(cptout);
