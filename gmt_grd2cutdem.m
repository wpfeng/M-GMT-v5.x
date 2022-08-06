function gmt_grd2cutdem(grd,demfile,demgrd,format)
%
%
%
%
% Created by Feng, W.P., @ GU, 21/10/2011
% Updated by FWP, @ YJ, 2015-04-17
% -> make it suitable for GMT5.x
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[t_mp,rootdem] = fileparts(demfile);
%
if nargin < 3
    demgrd = [rootdem,'.grd'];
end
if nargin < 4
    format = 'integer';
end
%
%
if ischar(grd)
   [grdregion,t_mp,t_mp,t_mp,t_mp,wid,len] = gmt_grd2info(grd);
else
   grdregion = grd(1:4);
   wid       = grd(5);
   len       = grd(6);
end
%
% cut data from raw file into a temporary file...
ntemp             = 0;
mtempfiles        = cell(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile          = [gmt_randname(5),'.grd'];
ntemp             = ntemp+1;
mtempfiles{ntemp} = tempfile;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_img2grd(demfile,tempfile,grdregion,format);
%
mregion = ['-R0/' num2str(wid-1),'/0/',num2str(len-1)];
editstr = [' gmt grdedit ',tempfile,' ', mregion,' -Vq'];
disp(editstr);
system(editstr);
%
isize     = ' -I1/1';
%
% Updated by FWP, @ YJ, 2015-04-17
% -Q is deprecated in GMT5.x, which is replaced by -n
% resampstr = ['grdsample ',tempfile,' -Qb -G' demgrd '  ' isize ' ' mregion];
resampstr = [' gmt grdsample ',tempfile,' -nb -G' demgrd '  ' isize ' ' mregion];
disp(resampstr);
system(resampstr);
%
%disp(georegion)
georegion = ['-R',num2str(grdregion(1),'%20.15f'),'/',num2str(grdregion(2),'%20.15f'),'/',...
                  num2str(grdregion(3),'%20.15f'),'/',num2str(grdregion(4),'%20.15f')];
newedit   = [' gmt grdedit ' demgrd ' ' georegion,' -Vq'];
disp(newedit);
system(newedit);
%
for ni = 1:ntemp
    if exist(mtempfiles{ni},'file')
        delete(mtempfiles{ni});
    end
end