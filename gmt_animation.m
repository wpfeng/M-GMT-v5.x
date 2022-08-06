function gmt_animation(obdir,searchingpost,outgif,outEPI,delay,loops)
%
%
%
% Developed by Feng, W.P., @ IGP, 2015-08-03
%
%
if nargin < 4
    outEPI = '720';
end
if nargin < 5
    delay = '20';
end
if nargin < 6
    loops = '0';
end
if nargin < 3
    outgif = [searchingpost,'.gif'];
end
%
inps = dir([obdir,'/',searchingpost,'*.ps']);
%
for ni = 1:numel(inps)
    %
    cps = [obdir,'/',inps(ni).name];
    [~,bname] = fileparts(inps(ni).name);
    outjpg    = [bname,'.jpg'];
    %
    if exist(outjpg,'file')
        disp([outjpg,' is already done. For next ...']);
    else
        %
        disp(['ps2raster ',cps,' -A -Tj -E',outEPI]);
        system(['ps2raster ',cps,' -A -Tj -E',outEPI]);
    end
    %
end
disp(['convert -delay ',delay,' -loop ',loops,' ',searchingpost,'*.jpg ',outgif]);
system(['convert -delay ',delay,' -loop ',loops,' ',searchingpost,'*.jpg ',outgif]);
%
%