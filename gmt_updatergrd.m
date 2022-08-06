function gmt_updatergrd(grd,updategrd)
%
%
% Created by Feng, W.P., @ GU, 03/10/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile = [gmt_randname(5),'.info'];
%
system(['gmt grdinfo ',grd,' > ',tempfile]);
fid = fopen(tempfile,'r');

while ~feof(fid)
    tline = fgetl(fid);
    if isempty(strfind(tline,'x_min'))==0
       tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %20.15f %s %s %s %f ');
       xmin = tmp{3};
       xmax = tmp{5};
       xsize  = tmp{7};
       wid    = tmp{11};
    end
    if isempty(strfind(tline,'y_min'))==0
       tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %20.15f %s %s %s %f');
       ymin = tmp{3};
       ymax = tmp{5};
       ysize  = tmp{7};
       len    = tmp{11};
    end
    if isempty(strfind(tline,'z_min'))==0
        tmp = textscan(tline,'%s %s %20.15f %s %20.15f %s %s');
        zmin = tmp{3};
        zmax = tmp{5};
    end
    
end
fclose(fid);
mgrdregion = [' -R' num2str(xmin,'%20.15f'),'/',...
                    num2str(xmax,'%20.15f'),'/',...
                    num2str(ymin,'%20.15f'),'/'...
                    num2str(ymax,'%20.15f')];
editstr = ['gmt grdedit ' updategrd ' ' mgrdregion];
disp(editstr);
system(editstr);
%
delete(tempfile);