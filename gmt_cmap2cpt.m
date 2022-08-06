function gmt_cmap2cpt(cmap,minx,maxx,cptname)
%
%
%
%
% created by Feng,W.P., @ GU, 2011/10/28
%
fid = fopen(cptname,'w');
%
fprintf(fid,'%s\n','# cpt file created by Wanpeng Feng');
fprintf(fid,'%s\n','#');
fprintf(fid,'%s\n','# COLOR_MODEL = RGB');
dv = linspace(minx,maxx,numel(cmap(:,1)));
%
for ni = 1:numel(cmap(:,1))
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
% br = fix(cmap(1,1).*255);
% bg = fix(cmap(1,1).*255);
% bb = fix(cmap(1,1).*255);
% 
% fr = fix(cmap(end,1).*255);
% fg = fix(cmap(end,1).*255);
% fb = fix(cmap(end,1).*255);
%
%fprintf(fid,'%s %3.0f %3.0f %3.0f\n','B ',[br,bg,bb]);
%fprintf(fid,'%s %3.0f %3.0f %3.0f\n','F ',[fr,fg,fb]);
fprintf(fid,'%s %3.0f %3.0f %3.0f\n','N ',[255 255 255]);
fclose(fid);