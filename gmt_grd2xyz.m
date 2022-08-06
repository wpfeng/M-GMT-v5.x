function gmt_grd2xyz(ingrd,outxyz,outformat)
%
%
% Developed by FWP, @ Vienna, 2013-04-08
%
%
if nargin<3
    outformat = 'f';
end
%
grd2xyz_str = ['grd2xyz ',ingrd,' -S -Z',outformat, ' >',outxyz];
grd2xyz_str = ['grd2xyz ',ingrd,' -S >',outxyz];
system(grd2xyz_str);