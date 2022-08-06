function [gmt_mregion,psbasemapstr,colorbarstr] = gmt_grdimageadddem(grd,varargin)
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
% Created by Feng, W.P., @ GU, 03/10/2011
% modified by Feng, W.P.,@ GU, 20/10/2011
%   Now working for colorful image overlaying on the relief ...
% Updated by FWP, @GU, 2014-10-09
%   gmt_background is available for psscale...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_psbasemap = 1;
gmt_mregion   = [];
gmt_proj      = '-JM4i';
gmt_dirrose   = '';
gmt_outps    = 'test.ps';
gmt_iskml    = 0;
gmt_isov     = 0;
gmt_iscon    = 0;
gmt_xoff     = '1i';
gmt_yoff     = '1i';
gmt_xtitle   = '';
gmt_ytitle   = '';
gmt_axstep   = '0.25';
gmt_aystep   = '0.25';
gmt_cptname  = [];
gmt_snew     = 'NEsw';
gmt_colorn   = 'seis';
gmt_unit     = '';
gmt_demgrd   = [];
gmt_scalecof = 1;
gmt_gradientmethod  = 'A';
gmt_nanvalue        = [];
gmt_zerovalue       = [];
gmt_zinterv         = [];
gmt_azimuth1        = 85;
gmt_azimuth2        = 135;
gmt_graddifusion    = 0.5;
gmt_mulvalue        = [];
gmt_outdpi          = 300;
gmt_iscolorbar      = 1;
gmt_colorbardir     = 'h';
gmt_colorbarxtitle  = '';
gmt_colorbaryoffset = '-0.2i';
gmt_colorbarlength  = [];
gmt_colorbarxoffset = [];
gmt_colorbarwidth   = '0.08i';
gmt_demdisplay      = '1.2 ';
gmt_lengthscale     = '';
gmt_lengthscaleframe= 0.12;
gmt_colorbarannotangle=[];
gmt_grdimageadddem   = 0.1;
gmt_e                = ' -E ';
gmt_background       = [];  % in default, unit is inch...
gmt_title            = '';
gmt_psscale_background_pen = 0;
gmt_psscale_background_fill= [];
gmt_psscale_background_offset = '0.01i';
gmt_psscale_background_offset_l = [];
gmt_psscale_background_offset_r = [];
gmt_psscale_background_offset_t = [];
gmt_psscale_background_offset_b = [];
gmt_transparency                = '0';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v = sim_varmag(varargin);
% for j = 1:length(v)
%     eval(v{j});
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Updated by Feng, W.P., @ YJ, 2015-04-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    %
    para   = varargin{ni};
    pvalue = varargin{ni+1};
    eval([para,'= pvalue;']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isnumeric(gmt_outdpi)
    gmt_outdpi = num2str(gmt_outdpi);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(gmt_demgrd) || exist(gmt_demgrd,'file')==0
    %
    disp(' gmt_grdimage: start...');
    [gmt_mregion,psbasemapstr,colorbarstr] =  gmt_grdimagev2(grd,...
        'gmt_mregion',  gmt_mregion,...
        'gmt_proj',     gmt_proj,...
        'gmt_outps',    gmt_outps,...
        'gmt_isov',     gmt_isov,...
        'gmt_iskml',    gmt_iskml,...
        'gmt_iscon',    gmt_iscon,...
        'gmt_xoff',     gmt_xoff,...
        'gmt_yoff',     gmt_yoff,...
        'gmt_dirrose',  gmt_dirrose,...
        'gmt_axstep',   gmt_axstep,...
        'gmt_aystep',   gmt_aystep,...
        'gmt_xtitle',   gmt_xtitle,....
        'gmt_dirrose',  gmt_dirrose,...
        'gmt_nanvalue', gmt_nanvalue,...
        'gmt_zerovalue',gmt_zerovalue,...
        'gmt_cptname',  gmt_cptname,...
        'gmt_colorn',   gmt_colorn,...
        'gmt_snew',     gmt_snew,...
        'gmt_ytitle',   gmt_ytitle,...
        'gmt_unit',                       gmt_unit,...
        'gmt_zinterv',                    gmt_zinterv,...
        'gmt_psscale_background_pen',     gmt_psscale_background_pen,...
        'gmt_psscale_background_fill',    gmt_psscale_background_fill,...
        'gmt_psscale_background_offset',  gmt_psscale_background_offset,...
        'gmt_psscale_background_offset_t',gmt_psscale_background_offset_t,...
        'gmt_psscale_background_offset_b',gmt_psscale_background_offset_b,...
        'gmt_psscale_background_offset_r',gmt_psscale_background_offset_r,...
        'gmt_psscale_background_offset_l',gmt_psscale_background_offset_l,...
        'gmt_title',             gmt_title,...
        'gmt_iscolorbar',        gmt_iscolorbar,...'gmt_cptname',gmt_cptname,...
        'gmt_colorbardir',       gmt_colorbardir,...
        'gmt_colorbarxtitle',    gmt_colorbarxtitle,...
        'gmt_colorbaryoffset',   gmt_colorbaryoffset,...
        'gmt_colorbarlength',    gmt_colorbarlength,...
        'gmt_colorbarxoffset',   gmt_colorbarxoffset,...
        'gmt_colorbarwidth',     gmt_colorbarwidth,...
        'gmt_demdisplay',        gmt_demdisplay,...
        'gmt_lengthscale',       gmt_lengthscale,...
        'gmt_colorbarannotangle',gmt_colorbarannotangle,...
        'gmt_zinterv',           gmt_zinterv,...
        'gmt_e',                 gmt_e,...
        'gmt_outdpi',            gmt_outdpi,...
        'gmt_unit',              gmt_unit,...
        'gmt_grdimageadddem',    gmt_grdimageadddem,...
        'gmt_lengthscaleframe',  gmt_lengthscaleframe,...
        'gmt_background',        gmt_background,...
        'gmt_transparency',      gmt_transparency,...
        'gmt_psbasemap',         gmt_psbasemap);
    return
    disp(' GMT_grdimage: end...');
end
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
%
if isempty(gmt_cptname)
    tempfile = [gmt_randname(5),'_IMG.cpt'];
    ntemp    = ntemp + 1;
    mtempfiles{ntemp} = tempfile;
    %
    disp(' Create CPTNAME NOW...!!!!');
    cptstr = [' gmt grd2cpt '  grd  ' -C' gmt_colorn ' -S' num2str(zmin),'/',num2str(zmax),'/' num2str((zmax-zmin)/256),' >',tempfile];
    disp(cptstr);
    system(cptstr);
    gmt_cptname = tempfile ;%'img.cpt';
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
    gmt_background = [str2double(cshift(1:end-1)), str2double(cshift(1:end-1)) + str2double(lens(1:end-1)),...
                      str2double(gmt_colorbaryoffset(1:end-1)),str2double(gmt_colorbaryoffset(1:end-1)) + str2double(gmt_colorbarwidth(1:end-1))];
    gmt_background = [gmt_background(1),gmt_background(3);...
                      gmt_background(1),gmt_background(4);...
                      gmt_background(2),gmt_background(4);...
                      gmt_background(2),gmt_background(3);...
                      gmt_background(1),gmt_background(3)];
    %
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
        colorbarstr = [' gmt psscale -C' gmt_cptname ' -D' cshift '/' gmt_colorbaryoffset '/' lens ...
            '/' gmt_colorbarwidth 'h ' annotvert,' ',gmt_psscale_background,' -B' gmt_zinterv ':"' ...
            ,gmt_colorbarxtitle '":/:"' gmt_unit '":' ' ' cgmt_iscon ' -O  ', gmt_e, ' >>' gmt_outps];
    otherwise
        colorbarstr = [' gmt psscale -C' gmt_cptname ' -D' cshift '/' gmt_colorbaryoffset '/' num2str(lens) ...
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
% A double input keyword was used in previous version. Fixed by FWP, @ YJ,
% 2015-04-17
if strcmpi(gmt_gradientmethod,'e')
    %
    gradientmethod = [' -E' num2str(gmt_azimuth1) '/' num2str(gmt_azimuth2) '/=/' num2str(gmt_graddifusion)];
else
    %
    gradientmethod = [' -A' num2str(gmt_azimuth1) '/' num2str(gmt_azimuth2)];
end
%
grdgradientstr = [' gmt grdgradient ' gmt_demgrd ' ',gradientmethod,' -Ne' gmt_demdisplay ' -V -Ggrad.grd'];
disp(grdgradientstr);
system(grdgradientstr);
%
if ( gmt_scalecof ~=1 )
    tempfile_texture = [gmt_randname(5),'_TEXTURE.grd'];
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile_texture;
    grdmathstr = [' gmt grdmath grad.grd ' num2str(gmt_scalecof) ' DIV = ',tempfile_texture];
    disp(grdmathstr);
    system(grdmathstr);
else
    tempfile_texture = 'grad.grd';
    ntemp = ntemp + 1;
    mtempfiles{ntemp} = tempfile_texture;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if isempty(gmt_zerovalue)==0
    %gmtmath2 = ['grdmath ' grd ' 0 EQ ' num2str(gmt_zerovalue) ' MUL ' grd  ' ADD = grd.grd'];
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
    gmtmath0 = [' gmt grdmath ' grd ' -0.000000000000000000000000000000000000001 GE  = ',tempfile1];
    gmtmath1 = [' gmt grdmath ' grd '  0.000000000000000000000000000000000000001 LT  = ',tempfile2];
    gmtmath2 = [' gmt grdmath ',tempfile1,'',tempfile2,' MUL  = ',tempfile];
    gmtmath3 = [' gmt grdmath ',tempfile,'  1 AND  = ',tempfile0];
    gmtmath4 = [' gmt grdmath ',tempfile0,' ', grd ' ADD  = ',tempfile3];
    %
    gmtmath5 = [' gmt grdmath ',tempfile3,' 0 NAN  = ' grd];
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
gmt_updatergrd(grd,tempfile_texture);
gmt_updatergrd(grd,grd);
%
if isempty(gmt_nanvalue)==0
    %
    tempfile4 = [gmt_randname(5),'_FLAG3.grd'];
    ntemp     = ntemp + 1;
    mtempfiles{ntemp} = tempfile4;
    gmtmath1 = [' gmt grdmath ' grd ' ' num2str(gmt_nanvalue) ' AND = ',tempfile4];
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
% -I',tempfile_texture,'
grdimagestr = [' gmt grdimage ' grd ' -I',tempfile_texture,' ',gmt_mregion,' ',gmt_proj, ' -P ',gmt_iscon,' -X' gmt_xoff ,' -Y' gmt_yoff  ...
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
psbasemapstr = [' gmt psbasemap ',gmt_mregion,' ',gmt_proj,' ',gmt_dirrose,' ', gmt_lengthscale,...
    ' ',kissue,' -P -X0i' ,' ', framepara,axisparax,axisparay,' -Y0i ' ,' -O >>',gmt_outps];
%
if gmt_psbasemap == 1
    %
    disp(psbasemapstr);
    system(psbasemapstr);%
end
%
if gmt_iscolorbar == 1
    %
    % Updated by fWp, @UoG, 2014-10-09
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
    ps2rasterstr = [' gmt ps2raster ' gmt_outps ' -Tf -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
    ps2rasterstr = [' gmt ps2raster ' gmt_outps ' -Tg -A -E' gmt_outdpi];
    disp(ps2rasterstr);
    system(ps2rasterstr);
end
%
for ni = 1:ntemp
    if exist(mtempfiles{ni},'file')
        delete(mtempfiles{ni});
        %
    end
end
