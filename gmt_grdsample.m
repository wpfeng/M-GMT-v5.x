function gmt_grdsample(grdfile,varargin)
%
%
%
%
%
% Created by Feng, W.P., @ GU, 2012-08-08
%
gmt_ggrd     = [];
gmt_outxsize = [];
gmt_outysize = [];
gmt_incscale = 0.5;
gmt_mregion  = [];
gmt_method   = 'n';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% re-code by varagin
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gmt_incscale
%
if isempty(gmt_ggrd)
    gmt_ggrd = [grdfile,'.r.grd'];
end
%
%
[grdregion,xsize,ysize] = gmt_grd2info(grdfile);
% a bug fixed by fWP, @IGPP, UCSD
% 2013-10-06
if ischar(gmt_incscale)
    gmt_incscale = str2double(gmt_incscale);
end
%
if isempty(gmt_outxsize) || isempty(gmt_outysize)
    gmt_outxsize = xsize*gmt_incscale;
    gmt_outysize = ysize*gmt_incscale;
end
%
%
%
if isempty(gmt_mregion)
    gmt_mregion = [ '-R',num2str(grdregion(1)),...
                    '/',num2str(grdregion(2)),...
                    '/',num2str(grdregion(3)),...
                    '/',num2str(grdregion(4))];
    %gmt_mregion = '';
end
%
% grdsample hawaii_5by5_topo.grd ?I1m ?Ghawaii_1by1_topo.grd
%
% updated by Feng, W.P., @ YJ, 2015-04-17
% -Q in grdsample is deprecated, which has been replaced by -n
%
% gmt_commond = ['grdsample ' grdfile, ' ',gmt_mregion,...
%     ' -I',num2str(gmt_outxsize),'/',num2str(gmt_outysize),...
%     ' -F -Q',MCM_rmspace(gmt_method),' -G' gmt_ggrd];
%
% by the way, -F in GMT4.x has been deprecated. Now -r replaced the old
% option.
%
gmt_commond = [' gmt grdsample ' grdfile, ' ',gmt_mregion,...
    ' -I',num2str(gmt_outxsize),'/',num2str(gmt_outysize),...
    ' -r -n',MCM_rmspace(gmt_method),' -G' gmt_ggrd];
disp(gmt_commond);
system(gmt_commond);