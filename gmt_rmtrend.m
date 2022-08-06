function gmt_rmtrend(imagefile,order)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    order  = 1;
end
%
[~,bname] = fileparts(imagefile);
%
grdname   = [bname,'.grd'];
%
gmt_img2grd(imagefile,grdname);
%
strendstr = ['grdtrend ' grdname ' -N' num2str(order) ' -Ttrend.grd'];
disp(strendstr);
system(strendstr);
%
%
mathstr   = ['grdmath ' grdname ' trend.grd SUB flag.grd MUL = tmp.grd'];
disp(mathstr);
system(mathstr);

movefile('tmp.grd',grdname);
%
gmt_grdimage(grdname,'gmt_proj','-JM4i');
%