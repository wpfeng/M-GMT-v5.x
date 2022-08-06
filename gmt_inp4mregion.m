function [gmt_mregion,ranges] = gmt_inp4mregion(infile)
%
%
%
%
% Created by FWP, @ GU, 2013-05-30
%
data = load(infile);
minx = min(data(:,1));
miny = min(data(:,2));
maxx = max(data(:,1));
maxy = max(data(:,2));
ranges      = [minx,maxx,miny,maxy];
gmt_mregion = [' -R',num2str(minx),'/',num2str(maxx),...
                 '/',num2str(miny),'/',num2str(maxy)];
             
