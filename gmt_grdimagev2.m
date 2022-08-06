function [gmt_mregion,psbasemapstr,colorbarstr] = gmt_grdimagev2(grd,varargin)
%
%
% GMT 5.x
% +Input:
%        grd, grd file
%    mregion, the plot region, -R/xmin/xmax/ymin/ymax
%      outps, the outps, outname
%       inov, if overly existing ps...
%      outov, if permit later layer overlay
%
% Created by Feng, W.P., @ UoG, 03/10/2011
% modified by Feng, W.P.,@ UoG, 20/10/2011
%   Now working for colorful image overlaying on the relief ...
% Updated by FWP, @ UoG, 2014-10-09
%   ->gmt_background is available for psscale...
%   ->A new version of grdimage for GMT5.x, by Feng, W.P., @ Yj, 2015-06-16
%
% Updated by Feng, W.P., @NRCan, 2015-10-07
%    -> make it available for GMT5.x in Linux 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_psbasemap  = 1;
gmt_mregion    = [];
gmt_proj       = '-JM4i';
gmt_dirrose    = '';
gmt_outps      = 'test.ps';
gmt_iskml      = 0;
gmt_isov       = 0;
gmt_iscon      = 0;
gmt_xoff       = '1i';
gmt_yoff       = '1i';
gmt_xtitle     = '';
gmt_axstep     = '0.25';
gmt_aystep     = '0.25';
gmt_cptname    = [];
gmt_snew       = 'NEsw';
gmt_colorn     = 'seis';
gmt_unit               = '';
gmt_nanvalue           = [];
gmt_zerovalue          = [];
gmt_zinterv            = [];
gmt_mulvalue           = [];
gmt_outdpi             = 300;
gmt_ytitle             = '';
gmt_iscolorbar         = 1;
gmt_colorbardir        = 'h';
gmt_colorbarxtitle     = '';
gmt_colorbaryoffset    = '0.4i';
gmt_colorbarlength     = '1.0i';
gmt_colorbarxoffset    = '0.65i';
gmt_colorbarwidth      = '0.08i'; 
gmt_lengthscale        = ''; 
gmt_colorbarannotangle = []; 
gmt_e                  = ' -E '; 
gmt_background         = [];  % in default, unit is inch...
gmt_title              = '';
gmt_psscale_background_pen      = '0.03i';
gmt_psscale_background_fill     = '200/200/200';
gmt_psscale_background_offset   = '0.065i';
gmt_psscale_background_offset_l = [];
gmt_psscale_background_offset_r = [];
gmt_psscale_background_offset_t = [];
gmt_psscale_background_offset_b = [];
gmt_transparency                = '0';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%
if isnumeric(gmt_outdpi)
    gmt_outdpi = num2str(gmt_outdpi);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
region = gmt_grd2region(grd);
%
if isempty(gmt_mregion)
    gmt_mregion= [' -R',num2str(region(1),'%20.15f'),'/',num2str(region(2),'%20.15f'),'/',num2str(region(3),'%20.15f'),'/',num2str(region(4),'%20.15f'),' '];
end
%
ntemp      = 0;
mtempfiles = cell(1);
%
if isempty(gmt_mulvalue)==0
    %
    if ischar(gmt_mulvalue)==0
        gmt_mulvalue = num2str(gmt_mulvalue);
    end
    tempfile = [gmt_randname(5),'.grd'];
    gmt_grdmath(grd,gmt_mulvalue,'MUL',tempfile);
    %
    grd   = tempfile;%
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile;
end
%
[mregion,t_mp,t_mp,zmin,zmax] = gmt_grd2info(grd);
if isempty(gmt_cptname)
    %
    tempfile = [gmt_randname(5),'_IMG.cpt'];
    ntemp    = ntemp + 1;
    mtempfiles{ntemp} = tempfile;
    %
    disp('Creating CPTNAME with GMT5.x in Linux...!!!!');
    cptstr = ['gmt grd2cpt '  grd  ' -C' gmt_colorn ' -S' num2str(zmin),'/',num2str(zmax),'/' num2str((zmax-zmin)/256),' >',tempfile];
    disp(cptstr);
    system(cptstr);
    gmt_cptname =tempfile ;%'img.cpt';
    %
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(gmt_zinterv)
    gmt_zinterv  = num2str(fix((zmax-zmin)/3*1000)./1000);
end
%
ttmp_iscon = gmt_iscon;
%
gmt_iscon  = 1;
%%%%%%%%%%%%%%
strtemp = MCM_rmspace(gmt_proj);
flag    = strfind(strtemp,'/');
if isempty(flag)
    lens   = str2double(strtemp(4:end-1));
else
    lens   = str2double(strtemp(4:flag-2));
end
cshift = lens/2;
switch ttmp_iscon
    case 1
        cgmt_iscon = ' -K ';
    otherwise
        cgmt_iscon = '    ';
end
%
lens = [num2str(lens),'i'];
if isempty(gmt_colorbarlength)==0
    lens = gmt_colorbarlength;
end
cshift = [num2str(cshift),'i'];
if isempty(gmt_colorbarxoffset)==0
    cshift = gmt_colorbarxoffset;
end
%
if isempty(gmt_colorbarannotangle)~=1
    annotvert = ' -Ac ';
else
    annotvert = ' ';
end
%
% script for psscale, colorbar
% 
if ~isempty(gmt_background)
    gmt_background     = [str2double(cshift(1:end-1)), str2double(cshift(1:end-1))              + str2double(lens(1:end-1)),...
                          str2double(gmt_colorbaryoffset(1:end-1)),str2double(gmt_colorbaryoffset(1:end-1)) + str2double(gmt_colorbarwidth(1:end-1))];
    gmt_background = [gmt_background(1),gmt_background(3);...
                      gmt_background(1),gmt_background(4);...
                      gmt_background(2),gmt_background(4);...
                      gmt_background(2),gmt_background(3);...
                      gmt_background(1),gmt_background(3)];
    %
    %psscale_background = ['echo ',num2str(gmt_background(1:4)),...
    %                      ' |psxy -R -J -O -K -Sr -D0/0 -G200/200/200', ' -W0.000p --ELLIPSOID=Sphere --MEASURE_UNIT=inch >>',gmt_outps];
end
%
% Updated by Feng, W.P., @ YJ, 2015-04-17
% A rectangle background can be given in plotting colorbar.
%
if str2double(gmt_psscale_background_pen(1:end-1)) ~= 0 || isempty(gmt_psscale_background_fill)==0
    %
    if isempty(gmt_psscale_background_offset_b)
        gmt_psscale_background_offset_b = gmt_psscale_background_offset;
    end
    if isempty(gmt_psscale_background_offset_l)
        gmt_psscale_background_offset_l = gmt_psscale_background_offset;
    end
    if isempty(gmt_psscale_background_offset_t)
        gmt_psscale_background_offset_t = gmt_psscale_background_offset;
    end
    if isempty(gmt_psscale_background_offset_r)
        gmt_psscale_background_offset_r = gmt_psscale_background_offset;
    end
    %
    gmt_psscale_background = [' -Tp+',gmt_psscale_background_pen,'+g',gmt_psscale_background_fill,...
                                '+l',gmt_psscale_background_offset_l,...
                                '+r',gmt_psscale_background_offset_r,...
                                '+t',gmt_psscale_background_offset_t,...
                                '+b',gmt_psscale_background_offset_b];
else
   gmt_psscale_background = ' ';
end
%
switch upper(gmt_colorbardir)
    case 'H'
        colorbarstr = ['gmt psscale -C' gmt_cptname ' -D' cshift '/' gmt_colorbaryoffset '/' lens ...
            '/' gmt_colorbarwidth 'h ' annotvert,' ',gmt_psscale_background,' -B' gmt_zinterv ':"' ...
            ,gmt_colorbarxtitle '":/:"' gmt_unit '":' ' ' cgmt_iscon '  -O  ', gmt_e, ' >>' gmt_outps];
    otherwise
        colorbarstr = ['gmt psscale -C' gmt_cptname ' -D' cshift '/' gmt_colorbaryoffset '/' num2str(lens) ...
            '/' gmt_colorbarwidth ' ' annotvert ' -B' num2str(gmt_zinterv) ':"' ...
            gmt_colorbarxtitle '":/:"' gmt_unit '":'  ' ' cgmt_iscon ' -O ',gmt_e,...
            gmt_psscale_background ' >>' gmt_outps];
end
%
if strcmpi(gmt_axstep,'')
    gmt_axstep = num2str((mregion(2)-mregion(1))/3);
end
if strcmpi(gmt_aystep,'')
    gmt_aystep = num2str((mregion(4)-mregion(3))/3);
end
%
switch gmt_isov
    case 0
        gmt_otype = ' >';
    otherwise
        gmt_otype = ' -O >>';
end
%
switch gmt_iscon
    case 1
        gmt_iscon = ' -K ';
    otherwise
        gmt_iscon = '    ';
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if isempty(gmt_zerovalue)==0
    %
    tempfile1 = [gmt_randname(5),'_FLAG1.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile1;
    %
    tempfile2 = [gmt_randname(5),'_FLAG2.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile2;
    tempfile = [gmt_randname(5),'_FLAG.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile;
    tempfile0 = [gmt_randname(5),'_FLAG.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile0;
    tempfile3 = [gmt_randname(5),'_FLAG3.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile3;
    %
    %
    gmtmath0 = ['gmt grdmath ' grd ' -0.000000000000000000000000000000000000001 GE  = ',tempfile1];
    gmtmath1 = ['gmt grdmath ' grd '  0.000000000000000000000000000000000000001 LT  = ',tempfile2];
    gmtmath2 = ['gmt grdmath ',tempfile1,' ',tempfile2,' MUL  = ',tempfile];
    gmtmath3 = ['gmt grdmath ',tempfile,'  1 AND  = ',tempfile0];
    gmtmath4 = ['gmt grdmath ',tempfile0,' ', grd ' ADD  = ',tempfile3];
    %
    gmtmath5 = ['gmt grdmath ',tempfile3,' 0 NAN  = ' grd];
    disp(gmtmath0);
    disp(gmtmath1);
    disp(gmtmath2);
    disp(gmtmath3);
    disp(gmtmath4);
    disp(gmtmath5);
    %
    system(gmtmath0);
    system(gmtmath1);
    system(gmtmath2);
    system(gmtmath3);
    system(gmtmath4);
    system(gmtmath5);
    %
end
%
% gmt_updatergrd(grd,tempfile_texture);
% gmt_updatergrd(grd,grd);
%
if isempty(gmt_nanvalue)==0
    %
    tempfile4 = [gmt_randname(5),'_FLAG3.grd'];
    ntemp     = ntemp + 1;
    mtempfiles{ntemp} = tempfile4;
    gmtmath1 = ['gmt grdmath ' grd ' ' num2str(gmt_nanvalue) ' AND = ',tempfile4];
    disp(gmtmath1);
    system(gmtmath1);
    movefile(tempfile4,grd);
    %
end
%
if gmt_iscolorbar == 1
    kissue = ' -K ';
else
    kissue = cgmt_iscon;
end
% 
grdimagestr = ['gmt grdimage ',grd,' ',gmt_mregion,' ',gmt_proj, ' -Q -P ',gmt_iscon,' -X' gmt_xoff ,' -Y' gmt_yoff  ...
               ' -t',gmt_transparency,'  -C' gmt_cptname ' ' ,gmt_otype,gmt_outps];
%
disp(grdimagestr);
system(grdimagestr);
%
% Updated by Feng. W.P., @ YJ, 2015-04-17
% New style for GMT5.x
%
if isempty(gmt_snew)
    framepara = '';
else
    if ~isempty(gmt_title)
        framepara = [' -B',gmt_snew,'+b+t"',gmt_title,'"'];
    else
        framepara = [' -B',gmt_snew,'+b'];
    end
end
%
if isnumeric(gmt_axstep)
    gmt_axstep = num2str(gmt_axstep);
end
if isnumeric(gmt_aystep)
    gmt_aystep = num2str(gmt_aystep);
end
%
if ~isempty(gmt_xtitle)
    axisparax     = [' -Bpx',gmt_axstep,'+l"',gmt_xtitle,'"'];
else
    axisparax     = [' -Bpx',gmt_axstep];
end
if ~isempty(gmt_ytitle)
    axisparay     = [' -Bpy',gmt_aystep,'+l"',gmt_ytitle,'"'];
else
    axisparay     = [' -Bpy',gmt_aystep];
end
%
psbasemapstr = ['gmt psbasemap ',gmt_mregion,' ',gmt_proj,' ',gmt_dirrose,' ', gmt_lengthscale,...
                ' ',kissue,' -P -X0i' ,' ', framepara, axisparax, axisparay,' -Y0i ' ,' -O >>',gmt_outps];
%
% 
if gmt_psbasemap == 1 && gmt_iskml~=1
    %
    disp(psbasemapstr);
    system(psbasemapstr);%
end
%
if gmt_iscolorbar == 1
    %
    % Updated by fWp, @GU, 2014-10-09
    if ~isempty(gmt_background)
       %
       gmt_psxy4polygon(gmt_background,...
           'gmt_outps',gmt_outps,...
           'gmt_isov', 1,...
           'gmt_iscon',1,...
           'gmt_snew','',...
           'gmt_xoff','0i',...
           'gmt_yoff','0i',...
           'gmt_axoff','100000',...
           'gmt_ayoff','100000',...
           'gmt_backgroundcolor','255/255/255',...
           'gmt_unit',' -W0.000p --ELLIPSOID=Sphere --MEASURE_UNIT=inch ');
       %
    end
    %
    disp(colorbarstr);
    system(colorbarstr);
end
%
if ttmp_iscon ~=1
    if gmt_iskml==0
    ps2rasterstr = ['gmt psconvert ' gmt_outps ' -Tf -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
    ps2rasterstr = ['gmt psconvert ' gmt_outps ' -TG -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
    else
        ps2rasterstr = ['gmt psconvert ' gmt_outps ' -Tf -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
    ps2rasterstr = ['gmt psconvert ' gmt_outps ' -TG -W+k+t',gmt_outps,' -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
    end
end
%
for ni = 1:ntemp
    if exist(mtempfiles{ni},'file')
        delete(mtempfiles{ni});
        %
    end
end
