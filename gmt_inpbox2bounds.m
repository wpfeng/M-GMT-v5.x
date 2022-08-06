function gmt_inpbox2bounds(xyf,outfile)
% 
% Show the Quadtree Region
% Created by Feng, Wanpeng, IGP/CEA,2009/06
%
if nargin < 3
    cproj = 'utm';
end
if nargin < 4
    czone = '46S';
end
if nargin < 5
   %inp
   data   = sim_inputdata(inp);
   crange = [min(data(:,3)),max(data(:,3))];
end
if nargin < 6
   ctmap = 'jet';
end
czone = MCM_rmspace(czone);
czone = [czone(end-2:end-1),' ',czone(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%colormap(ctmap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(xyf,'r');
outd= [];
while feof(fid)==0 
    tfline = fgetl(fid);
    index  = strfind(tfline,'>');
    if isempty(index)==1
       tmp  = textscan(tfline,'%f%f');
       outd = [outd;tmp{1},tmp{2}];
    end
end
fclose(fid);
nregion = size(outd,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fidoutfile = fopen(outfile,'w');
%
for ni=1:nregion/5
    X = outd((ni-1)*5+1:(ni-1)*5+5,1);
    Y = outd((ni-1)*5+1:(ni-1)*5+5,2);
    %
    xmean = mean(X(:));
    ymean = mean(Y(:));
    dist  = sqrt((inps(:,1)-xmean).^2+(inps(:,2)-ymean).^2);
    index = find(dist==min(dist(:)));
    %Z     = X.*0+inps(index(1),3);
    %patch(X,Y,Z);
    fprintf(fidoutfile,'%s\n','>');%['> -Z',num2str(Z(1))]);
    fprintf(fidoutfile,'%f %f\n',[X(:),Y(:)]');
end
fclose(fidoutfile);
