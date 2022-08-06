function [xoff,yoff,iscon,isov,boundary] = gmt_sortplot(numraw,numcol,noi,xwidth,yhigh,xstart,ystart,isov0,iscon1,framewidth)
%
%
%
% Created by Feng, W.P., @ GU, 18/06/2012
% latest updated by FWP, 20121014, add more ouput for "snew".
% Updated by Feng, W.P., @ YJ, 2015-04-17
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 4
    xwidth = 4;
end
if nargin < 5
    yhigh = 4;
end
if nargin < 6 
    xstart = 4;
end
if nargin < 7 
    ystart = 20;
end
if nargin < 8
    isov0 = 0;
end
%
if nargin < 9
    iscon1 = 0;
end
if nargin < 10
    framewidth = gmt_defaults('gmt_frame_width');
    framewidth = str2double(framewidth(1:end-1));
    %framewidth = framewidth/2.54;
    
end
%
boundary  = 'snew';
[raw,col] = ind2sub([numraw,numcol],noi);
%
% updated by FWP,2012-10-14,judge the boundary...
if raw == 1
    boundary(4) = upper(boundary(4));
end
if raw == numraw
    boundary(3) = upper(boundary(3));
end
if col == 1
    if yhigh > 0
        boundary(1) = upper(boundary(1));
    else
        boundary(2) = upper(boundary(2));
    end
end
if col == numcol
    if yhigh > 0
        boundary(2) = upper(boundary(2));
    else
        boundary(1) = upper(boundary(1));
    end
end
%%%%%
%
if col == 1
    %
    if raw == 1
        xoff = xstart;
        yoff = ystart;
    else
        xoff = xwidth+framewidth*2;
        yoff = 0;
    end
else
    if raw == 1
        %
        xoff = -1*(numraw-1).*(xwidth+framewidth.*2);
        if yhigh > 0
            yoff = yhigh +  framewidth*2;
        else
            yoff = yhigh - framewidth*2;
        end
    else
        xoff = xwidth+framewidth*2;
        yoff = 0;
    end
end
%
% if col*raw ~= 1
%     if yoff > 0
%         yoff = -1*yoff;
%     end
% end
%
xoff = [num2str(xoff),'i'];
yoff = [num2str(yoff),'i'];
%
if noi == 1
    if noi < numraw*numcol
        iscon = 1;
    else
        iscon = 0;
    end
    isov  = isov0;
else
    if noi == numraw*numcol
        iscon = iscon1;
        isov  = 1;
    else
        iscon = 1;
        isov  = 1;
    end
    %
end
% if iscon == 0
%     boundary(1) = upper(boundary(1));
% end
% %
%
