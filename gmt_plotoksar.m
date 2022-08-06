function gmt_plotoksar(ingmtsar)
%
%
%
% Developed by FWP, @ IGPP of SIO,UCSD, 2013-09-30
%
fpara   = sim_oksar2SIM(ingmtsar);
%
utmzone = sim_oksar2utm(ingmtsar);
%
for ni = 1:numel(fpara(:,1))
    [x1,y1,z1] = sim_fpara2corners(fpara(ni,:),'ur');
    [x2,y2,z2] = sim_fpara2corners(fpara(ni,:),'ul');
    [lat,lon] = utm2deg([x1;x2].*1000,[y1;y2].*1000,utmzone);
    %
    hold on
    plot(lon,lat,'-r','LineWidth',2);
end


