function outnamepoly = gmt_oksar2geopolygon(oksar,utmzone,isvalue,varargin)

%
%  Created by Feng, W.P., @ UoG, 2012-08-12
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 3
    isvalue = 0;
end
%
if nargin < 2
    %
    utmzone = sim_oksar2utm(oksar);
end
%
sliptype = 'SYN';
frictioncoef = 0.25;
%
%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
%
[tmp_,tmp_,post] = fileparts(oksar);
%
switch upper(post)
    case '.OKSAR'
        [fpara,zone] = sim_oksar2SIM(oksar);
    otherwise
        [fpara,zone] = sim_simp2fpara(oksar);
end
%
if isempty(utmzone)==0
    if isempty(zone)==0
        utmzone = zone;
    end
end
%
[tmp_,bname] = fileparts(oksar);
outnamepoly   = [bname,'.geoslip.polygon'];
outnamexyz    = [bname,'.geoslip.point'];
outnamevect   = [bname,'.geoslip.xy'];
%
fidpoly = fopen(outnamepoly,'w');
fidxyz  = fopen(outnamexyz,'w');
fidvec  = fopen(outnamevect,'w');
%
for ni = 1:numel(fpara(:,1))
    ifpara = fpara(ni,:);
    [ix1,iy1,iz1] = sim_fpara2corners(ifpara,'ur','UTM','LL',utmzone);
    [ix2,iy2,iz2] = sim_fpara2corners(ifpara,'ul','UTM','LL',utmzone);
    [ix3,iy3,iz3] = sim_fpara2corners(ifpara,'ll','UTM','LL',utmzone);
    [ix4,iy4,iz4] = sim_fpara2corners(ifpara,'lr','UTM','LL',utmzone);
    %
    polygon       = [ix1,iy1;ix2,iy2;ix3,iy3;ix4,iy4;ix1,iy1];
    
    meanx         = mean(polygon(:,1));
    meany         = mean(polygon(:,2));
    %
    switch upper(sliptype)
        
        case 'STRIKE'
            synslip = ifpara(8);
        case 'DIP'
            synslip = ifpara(9);
        case 'COL'
            synslip = ifpara(8)-frictioncoef*ifpara(9);
        otherwise
            synslip = sqrt(ifpara(8).^2+ifpara(9).^2);
    end
    %
    if isvalue == 1
        fprintf(fidpoly,'%s %s \n',['> -Z',num2str(synslip)],'-W0.0p');
    else
        fprintf(fidpoly,'%s  \n','>');
    end
    fprintf(fidpoly,'%f %f\n',polygon');
    %
    fprintf(fidxyz,'%f %f %f\n',meanx,meany,synslip);
    %
    [xslip,yslip] = sim_rotaxs(ifpara(8),ifpara(9),ifpara(3)*-1,0,0,0);
    fprintf(fidvec,'%f %f %f %f\n',meanx,meany,xslip,yslip);
end
fclose(fidpoly);
fclose(fidxyz);
fclose(fidvec);