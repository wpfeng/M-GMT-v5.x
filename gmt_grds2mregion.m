function [refregion,mregion] = gmt_grds2mregion(grds)
%
%
%
% Developed by FWP, @IGPP of SIO, 2013-11-18
%
for ni = 1:numel(grds)
    [grdregion,xsize,ysize,zmin,zmax,wid,len,mregion] = gmt_grd2info(grds{ni});
    if ni == 1
        refregion = grdregion;
    else
        refregion(1) = (refregion(1)<grdregion(1))*refregion(1) + (refregion(1)>=grdregion(1))*grdregion(1);
        refregion(2) = (refregion(2)>grdregion(2))*refregion(2) + (refregion(2)<=grdregion(2))*grdregion(2);
        refregion(3) = (refregion(3)<grdregion(3))*refregion(3) + (refregion(3)>=grdregion(3))*grdregion(3);
        refregion(4) = (refregion(4)>grdregion(4))*refregion(4) + (refregion(4)<=grdregion(4))*grdregion(4);
        
    end
end
mregion = ['-R',num2str(refregion(1)),'/',...
                num2str(refregion(2)),'/',...
                num2str(refregion(3)),'/',...
                num2str(refregion(4))];

    