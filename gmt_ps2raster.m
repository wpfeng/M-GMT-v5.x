function gmt_ps2raster(dirs,filename)
%
% it's a batch job...
%
% Created by Feng, W.P., @ GU, 06/10/2011
%
allfile = dir([dirs,'/',filename]);
if numel(allfile) > 1
    for ni = 1:numel(allfile)
        cfile = fullfile(dirs,allfile(ni).name);
        ps2rasterstr = ['ps2raster ',cfile,' -Tg -E300 -A'];
        disp(ps2rasterstr);
        system(ps2rasterstr);
    end
end