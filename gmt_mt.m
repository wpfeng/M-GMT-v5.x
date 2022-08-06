function gmt_mt(indata,varargin)
%
%
% M-T chart 
% by Feng, W.P., @ IGP/CEA, 2015-07-29
%
gmt_outps   = 'example_7.ps';
gmt_xtitle  = 'Date(Dec. Year)';
gmt_ytitle  = 'Magnitude(ML)';
gmt_title   = '';
gmt_ptype   = 'c';
gmt_xoff    = '4i';
gmt_yoff    = '4i';
gmt_psize   = '0.1';
gmt_pfillc  = '150/0/0';
gmt_lwid    = '0.0125c,gray';
gmt_xastep  = '5';
gmt_yastep  = '2';
gmt_snew    = 'SnWe';
gmt_proj    = ' -JX4i/1i ';
gmt_mregion = '';
%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
%
if isempty(gmt_mregion)
    mindate     = min(indata(:,1));
    maxdate     = max(indata(:,1));
    gmt_mregion = [' -R',num2str(mindate),'/',num2str(maxdate),'/',num2str(min(indata(:,2))),'/',num2str(max(indata(:,2))),' '];
end

gmt_psxy4points(indata,...
    'gmt_proj',   gmt_proj,...
    'gmt_mregion',gmt_mregion,...
    'gmt_isov',   0,...
    'gmt_iscon',  0,...
    'gmt_xtitle', gmt_xtitle,...
    'gmt_snew',   gmt_snew,...
    'gmt_title',  gmt_title,...
    'gmt_ytitle', gmt_ytitle,...
    'gmt_xoff',   gmt_xoff,...
    'gmt_yoff',   gmt_yoff,...
    'gmt_ptype',  gmt_ptype,...
    'gmt_xastep', gmt_xastep,...
    'gmt_yastep', gmt_yastep,...
    'gmt_psize',  gmt_psize,...
    'gmt_pfillc', gmt_pfillc,...
    'gmt_lwid',   gmt_lwid,...
    'gmt_outps',  gmt_outps);