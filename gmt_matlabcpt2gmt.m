function gmt_matlabcpt2gmt(cmap,cptname)
%
%
%
%
% created by Feng,W.P., @ GU, 2014-08-16
%
fid = fopen(cptname,'w');
%
fprintf(fid,'%s\n','# cpt file created by Wanpeng Feng');
fprintf(fid,'%s\n','# COLOR_MODEL = RGB');
fprintf(fid,'%s\n','#');
minx = 0;
maxx = 1;
dv = linspace(minx,maxx,numel(cmap(:,1)));
%
for ni = 1:numel(cmap(:,1))-1
    %
    n1 = ni;
    n2 = ni+1;
    %
    r = fix(cmap(n1,1).*255);
    g = fix(cmap(n1,2).*255);
    b = fix(cmap(n1,3).*255);
    if n2 <= numel(cmap(:,1))
        r2 = fix(cmap(n2,1).*255);
        g2 = fix(cmap(n2,2).*255);
        b2 = fix(cmap(n2,3).*255);
        fprintf(fid,'%f %3.0f %3.0f %3.0f %f %3.0f %3.0f %3.0f\n',[dv(n1) r g b dv(n2) r2 g2 b2]);
    else
        fprintf(fid,'%f %3.0f %3.0f %3.0f\n',[dv(n1) r g b]);
    end
end
%
% B	0	124	50
% F	255	255	255
% N	255	255	255
fprintf(fid,'%s %3.0f %3.0f %3.0f\n','B ',[255 255 255]);
fprintf(fid,'%s %3.0f %3.0f %3.0f\n','F ',[0 0 0]);
fprintf(fid,'%s %3.0f %3.0f %3.0f\n','N ',[255 255 255]);
fclose(fid);