function gmt_grdcut(grd,roi,outgrd)
%
% convert imagefile into grd file for gmt mapping
% Modification History:
% Created by Feng, W.P., 2011-08-31, @ BJ
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3
    disp('gmt_grdcut(grd,roi,outgrd)');
    return
end
%
mregion = [' -R',...
    num2str(roi(1),'%20.15f'),'/',...
    num2str(roi(2),'%20.15f'),'/',...
    num2str(roi(3),'%20.15f'),'/',...
    num2str(roi(4),'%20.15f')];
%
%
strcommand = ['grdcut ' grd ' ' mregion ' -G' outgrd];
disp(strcommand);
system(strcommand);
%
outstr = gmt_randname(4);
strix      = ['grdinfo -I ' outgrd ' >',outstr '.info'];
disp(strix);
system(strix);
strgrdedit = ['grdedit ' outgrd ' ' mregion];
system(strgrdedit);
%
fid = fopen([outstr,'.info'],'r');
ix  = textscan(fid,'%s\n');
ix  = ix{1}{1};
fclose(fid);
%
% Updated for GMT5.x, by Feng, W.P., @ YJ, 2015-05-09
%
strsample = ['grdsample ' outgrd ' ' mregion ' ' ix ' -nb -G' outgrd];
system(strsample);
delete([outstr,'.info']);
%
%
