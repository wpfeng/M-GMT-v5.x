function sar_hdr2rsc(hdrfile,outrsc)
%
% Create by Feng, W.P., @ BJ, 09/01/2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    outrsc = 'test.img.rsc';
end
hdrinfo = read_envihdr(hdrfile);
%
%
%
info             = sim_roirsc();
info.width       = hdrinfo.samples;
info.file_length = hdrinfo.lines;
info.xmax        = info.width - 1;
info.ymax        = info.file_length - 1;
%
% updated by fWP, 2013-05-01
%
if isfield(hdrinfo,'map_info')
    %
    info.x_first = hdrinfo.map_info.mapx;
    info.y_first = hdrinfo.map_info.mapy;
    info.x_step  = hdrinfo.map_info.dx;
    info.y_step  = hdrinfo.map_info.dy*-1;
    %
    if isfield(hdrinfo.map_info,'units')
       info.x_unit  = hdrinfo.map_info.units;
       info.datum   = hdrinfo.map_info.datum;
    end
end

if isfield(hdrinfo,'map_info') 
    proj = 'LL';
else
    proj = 'UTM';
end
if isfield(hdrinfo,'map_info') %isfield(hdrinfo.map_info,'zone')
    %
    if isempty(strfind(hdrinfo.map_info.projection,'UTM'))
        %
        mapx = hdrinfo.map_info.mapx;
        mapy = hdrinfo.map_info.mapy;
        [t_mp,t_mp,zone] = deg2utm(mapy,mapx);
        hdrinfo.map_info.zone = zone;
        %
    end
    zone = MCM_rmspace(hdrinfo.map_info.zone);
else
    zone = '30S';
end
info.zone       = zone;
info.projection = proj;
sim_croirsc(outrsc,info);
