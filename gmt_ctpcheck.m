function gmt_ctpcheck(cptname)
%
%
% Created by FWP, @ GU, 2012-11-25
% check CPT, make a quick figure for cpt file...
%
%
lons   = [100,110];
lats   = [35,35.8];
outimg = 'test_cpt.img'; 
cptout = 'tmp_cpt.cpt';
[bdir,bname] = fileparts(cptname);
cptps  = fullfile(bdir,[bname,'.ps']);
%
%
data = zeros(100,10);
for ni = 1:100
    data(ni,:) = ni/100;
end
info = sim_roirsc();
info.x_first = 100;
info.y_first = 35;
info.width   = 100;
info.file_length = 10;
%
sim_roi2ENVI(data,info,outimg);
%
gmt_makecpt(...
    'gmt_colorn',cptname,...
    'gmt_cptname',cptout);
%
gmt_img2ps(outimg,...
    'wrap',0,...
    'gmt_cptname',cptout,...
    'gmt_iscolorbar',0,...
    'gmt_snew','',...
    'gmt_outps',cptps);
    
