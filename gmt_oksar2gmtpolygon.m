function gmt_oksar2gmtpolygon(oksar,utmzone)
%
%
%
% created by Feng, W.P., 2011-10-29, @ GU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 2
    utmzone = [];
end
%
zone = sim_oksar2utm(oksar);
%
if isempty(utmzone)==0
    if isempty(zone)==0
        utmzone = zone;
    end
end
%
[~,bname] = fileparts(oksar);
outnamepoly   = [bname,'.slip.polygon'];
outnamexyz    = [bname,'.slip.point'];
outnamevect  = [bname,'.slip.xy'];
%
fpara = sim_oksar2SIM(oksar);
%whos fpara
[X,Y,Cx,Cy,Aslip,offx,offy,ind] = sim_plot2d(fpara,1,'fpara');
%
fidpoly  = fopen(outnamepoly,'w');
fidpoint = fopen(outnamexyz,'w');
fidvec   = fopen(outnamevect,'w');
%
for ni = 1:numel(X(1,:))
    poly = [X(:,ni) Y(:,ni)];
    poly(:,2) = poly(:,2).*-1;
    fprintf(fidpoly,'%s %s \n',['> -Z',num2str(sqrt(Aslip(ni,1).^2+Aslip(ni,2).^2))],'-W0.0p');
    if isempty(utmzone)==0
        [xlat,xlon] = utm2deg((poly(:,1)+offx).*1000,(poly(:,2)+offy).*1000,utmzone);
        poly(:,1) = xlon;
        poly(:,2) = xlat;
        %
        [xlat,xlon] = utm2deg(Cx(ni).*1000,Cy(ni).*1000,utmzone);
        Cx(ni)      = xlon;
        Cy(ni)      = xlat;
        %
        %[xlat,xlon] = utm2deg(Cx(ni).*1000,Cy(ni).*1000,utmzone);
        %Cx(ni)      = xlon;
        %Cy(ni)      = xlat;
    end
    fprintf(fidpoly,'%f %f \n',[poly ;poly(1,:)]');
    %fprintf(fidpoint,'%s \n','');
    fprintf(fidpoint,'%f %f %f\n',[Cx(ni),Cy(ni).*-1,sqrt(Aslip(ni,1).^2+Aslip(ni,2).^2)]);
    fprintf(fidvec,'%f %f %f %f\n',[Cx(ni),Cy(ni),Aslip(ni,1),Aslip(ni,2)]);
end
fclose(fidpoly);
fclose(fidpoint);
fclose(fidvec);
