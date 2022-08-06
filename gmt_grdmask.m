function gmt_grdmask(inoksar,varargin)
%
% Create a mask file to mask fault out
% a first version is worked for fault model in oksar format...
%
% Fault Slip Model...
% 
% Developed by Feng, W.P., @ Yj, 2015-05-12
%
inputtype   = 'oksar';
gmt_outgrd  = 'mask.grd';
gmt_mregion = [];
gmt_xsize   = [];
gmt_ysize   = [];
gmt_isroi   = 1;
%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
if ~exist(inoksar,'file')
    disp([inoksar,' was not found!']);
    return
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
switch upper(inputtype)
    case 'OKSAR'
        %
        fpara     = sim_oksar2SIM(inoksar);
        [xul,yul] = sim_fpara2corners(fpara,'ul');
        [xur,yur] = sim_fpara2corners(fpara,'ur');
        [xll,yll] = sim_fpara2corners(fpara,'ll');
        [xlr,ylr] = sim_fpara2corners(fpara,'lr');
        %
        x         = [xul,xur,xlr,xll,xul];
        y         = [yul,yur,ylr,yll,yul];
        zone      = sim_oksar2utm(inoksar);
        [lat,lon] = utm2deg(x.*1000,y.*1000,zone);
        %
        inxy      = '_tmp.inp';
        %
        fid = fopen(inxy,'w');
        fprintf(fid,'%f %f\n',[lon(:),lat(:)]');
        fclose(fid);
        %
    otherwise
        inxy      = inoksar;
end
data   = load(inxy);
minlon = min(data(:,1));
maxlon = max(data(:,1));
minlat = min(data(:,2));
maxlat = max(data(:,2));
%
if isempty(gmt_mregion)
   gmt_mregion = [' -R',num2str(minlon),'/',...
                        num2str(maxlon),'/',...
                        num2str(minlat),'/',...
                        num2str(maxlat),' '];
end
%
if isempty(gmt_xsize)
    gmt_xsize = (maxlon-minlon)/100;
end
if isempty(gmt_ysize)
    gmt_ysize = (maxlat-minlat)/100;
end
%
grdmaskexecu = ['gmt grdmask ',inxy,' ',gmt_mregion,' -I',num2str(gmt_xsize),'/',num2str(gmt_ysize),...
                ' -G',gmt_outgrd];
disp(grdmaskexecu);
system(grdmaskexecu);
%
if gmt_isroi == 1
    [outdir,bname] = fileparts(gmt_outgrd);
    if isempty(outdir)
        outdir = '.';
    end
    %
    outroi    = [outdir,'/',bname,'.msk'];
    gmt_grd2roi(gmt_outgrd,outroi,'f');
end
%


