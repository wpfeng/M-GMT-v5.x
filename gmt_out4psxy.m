function gmt_out4psxy(x,y,outname)
%
%
%
% Created by Feng, W.P., @ GU, 07/10/2011
%
fid = fopen(outname,'w');
for ni = 1:numel(x)
    tx = x{ni};
    ty = y{ni};
    fprintf(fid,'%s\n','>');
    fprintf(fid,'%f %f \n',[tx(:) ty(:)]');
end
fclose(fid);