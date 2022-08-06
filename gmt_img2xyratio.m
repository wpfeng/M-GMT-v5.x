function scale = gmt_img2xyratio(rsc,mode)
%
%
% Developed by FWP, @IGPP of SIO, 2013-11-29
% Updated by Feng, W.P. ,@NRCan, 2015-10-07
%
%
if nargin < 2
    mode = 'll';
end
%
roi = sar_rsc2roi(rsc);
cx  = mean(roi(1:2));
cy  = mean(roi(3:4));
ps  = [cx,cy;...
    cx+0.001,cy;...
    cx,cy+0.001];
%
%
[t_mp,t_mp,zone] = deg2utm(cy,cx);
[x,y]      = deg2utm(ps(:,2),ps(:,1),zone);
disx       = x(2)-x(1);
disy       = y(3)-y(1);
switch upper(mode)
    %
    case 'LL'
        scale = disy./disx*(roi(4)-roi(3))/(roi(2)-roi(1));
    otherwise
        scale = (roi(4)-roi(3))/(roi(2)-roi(1));
end
