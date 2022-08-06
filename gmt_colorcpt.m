function gmt_colorcpt(cmin,cmax,clevel,cname,gmt_outcpt)
%
%
% created by Feng, W.P., @ UoG, 03/10/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
   cmin = -1;
end
if nargin < 2
   cmax = abs(xmin)*2;
end
if nargin < 3
    clevel = 512;
end
if nargin < 4
   cname = 'rainbow';
end
%
deta = (cmax-cmin)/clevel;
%
%
makecptstr = [' gmt makecpt -T' num2str(cmin),'/',num2str(cmax),'/',num2str(deta),' -C',cname,' > ',gmt_outcpt];
disp(makecptstr);
system(makecptstr);


