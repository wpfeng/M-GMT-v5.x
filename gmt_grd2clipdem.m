function gmt_grd2clipdem(demgrd,roi,refgrd,outgrd)
%
%
%
%
% Created by Feng, W.P., @ GU, 2012-08-08
%
if nargin < 4
    outgrd = [demgrd,'.clip.grd'];
end
gmt_grdcut(demgrd,roi,outgrd);
%
if ischar(refgrd)
   [grdregion,xsize,ysize,~,~,wid,len] = gmt_grd2info(refgrd);
else
   grdregion = refgrd(1:4);
   wid       = refgrd(5);
   len       = refgrd(6);
end
%
mregion = [' -R0/' num2str(wid-1),'/0/',num2str(len-1)];
editstr = ['grdedit ' outgrd ' ' mregion];
disp(editstr);
system(editstr);
%
isize     = ' -I1/1';
%resampstr = ['grdsample _tmp.grd -G' demgrd ' -F -Lx ' newregion];
resampstr = ['grdsample  ' outgrd '  -Qb -G' outgrd '  ' isize ' ' mregion];
disp(resampstr);
system(resampstr);
%system('grdinfo -L _tmp.grd');

%
%disp(georegion)
georegion = [' -R',num2str(grdregion(1),'%20.15f'),'/',num2str(grdregion(2),'%20.15f'),'/',...
                  num2str(grdregion(3),'%20.15f'),'/',num2str(grdregion(4),'%20.15f')];
newedit   = ['grdedit ' outgrd ' ' georegion];
disp(newedit);
system(newedit);