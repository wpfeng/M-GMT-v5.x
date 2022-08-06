%
%
% batch plot
% W.P. Feng, @ GU
unws = dir('*.unw');
for ni = 1:numel(unws);
    cfile = unws(ni).name;
    gmt_img2ps(cfile);
end