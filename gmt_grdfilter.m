function gmt_grdfilter(grdfile,varargin)
%
%
%
%
% Created by Feng,W.P., @ GU, 2012-08-13
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 1
    disp('gmt_grdfilter(grdfile,varargin)');
    return
end
%
gmt_distance_flag = 4;   % could be 0,1,2,3,4,5
gmt_filtertype    = 'g'; % in default, g for gaussian
gmt_filterwidth   = 300; % when gmt_distance_flag is 4, filter_width will be in km by spherical calculation.
gmt_filtermode    = '';
gmt_outgrd        = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
v = sim_varmag(varargin);
for j = 1:length(v)
    %disp(v);
    eval(v{j});
end
%
if isempty(gmt_outgrd)
    gmt_outgrd = grdfile;
end
if isnumeric(gmt_filterwidth)
    gmt_filterwidth = num2str(gmt_filterwidth);
end
if isnumeric(gmt_distance_flag)
    gmt_distance_flag = num2str(gmt_distance_flag);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
gmt_command = ['grdfilter ' grdfile,' -D',gmt_distance_flag,' -F',...
     gmt_filtertype,...
     gmt_filterwidth,...
     gmt_filtermode,...
     ' -Nr ',...
     ' -G',...
     gmt_outgrd];
disp(gmt_command);
system(gmt_command);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%