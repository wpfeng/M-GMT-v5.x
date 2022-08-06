function [outregion,gmt_proj,gmt_mregion,psbasemapstr,colorbarstr] = gmt_img2ps(imgfile,varargin)
%%
%
% 
%  created by Feng, W.P. @ GU, 2012-05-06
%%
% New option, gmt_psbasemap, working for judgement if need plot
% More details for advanced use:
% gmt_lengthscale, ' -Lfx0.4i/0.3i/0/200k+lkm+jt ';
%%
% Note for generating a PNG for google Earth
%
% gmt_img2ps('F:\QH\ROI_PROC_140429\GMTPLOT\geo-20081105-20090708-MW6309.ImG',...
%            'gmt_iskml',1,...
%            'gmt_proj',' -JQ95.85/37.5/4i ',...  % specific projection for a KML file
%            'iswrap',1,...
%            'gmt_minwrap',-3.14,...
%            'gmt_maxwrap',3.14,...
%            'gmt_isov',0,...
%            'gmt_iscon',0)
%
%%
if nargin < 1
    disp('[outregion,gmt_proj,gmt_mregion,psbasemapstr,colorbarstr] = gmt_img2ps([infile],...');
    disp(['    ','''','gmt_inputformat','''',',','''','integer','''',',...']);
    disp(['    ','''','gmt_proj','''',',','''','-JM4i','''',',...']);
    disp(['    ','''','gmt_cptname','''',',','''','gmt_cptname',',...']);
    disp(['    ','''','gmt_scale','''',',1,....']);
    disp(['    ','''','gmt_demgrd','''',',demgrd,...']);
    disp(['    ','''','gmt_demdisplay','''',',','''','0.6 ','''',',...']);
    disp(['    ','''','gmt_scalecof','''',',1,...']);
    disp(['    ','''','gmt_minwrap','''',',[],...']);
    disp(['    ','''','gmt_maxwrap','''',',[],...']);
    disp(['    ','''','gmt_colorn','''',',','''','topo','''',',...']);
    disp(['    ','''','gmt_azimuth1','''',',250,...']);
    disp(['    ','''','gmt_azimuth2','''',',0,',',...']);
    disp(['    ','''','gmt_zinterv','''',',num2str(500),...']);
    disp(['    ','''','gmt_axstep','''',',','''','1','''',',...']);
    disp(['    ','''','gmt_iscolorbar','''',',0,...']);
    disp(['    ','''','gmt_aystep','''',',','''','1','''',',...']);
    disp(['    ','''','gmt_zinterv','''',',','''','30f10','''',',...']);
    disp(['    ','''','gmt_iscon','''',',1,...']);
    disp(['    ','''','gmt_unit','''',',','''','Meters','''',',...']);
    disp(['    ','''','gmt_lengthscale','''',',','''',' -Lfx0.5i/0.3i/0/50k+lkm+jt ','''',',...']);
    disp(['    ','''','gmt_colorbarxoffset','''',',','''','3i','''',',...']);
    disp(['    ','''','gmt_colorbarlength','''',',','''','1i','''',',',',...']);
    disp(['    ','''','gmt_colorbaryoffset','''',',','''','0.3i','''',',...']);
    disp(['    ','''','gmt_outps','''',',gmt_outps,...']);
    disp(['    ','''','gmt_colorbarwidth','''',',','''','0.08i','''',');']);
    return
end
global gmt_version
gmt_version      = 5;
gmt_iskml        = 0;
gmt_fillinnan    = 0;
gmt_psbasemap    = 1;
roi              = [];
gmt_inputformat  = 'float';
iswrap           = 0;
minwrap          = -3.15;
maxwrap          =  3.15;
gmt_scale        = 1;
opvalue          = 1;
gmt_nanvalue     = [];
gmt_cptname      = [];
gmt_axstep       = '0.25';
gmt_aystep       = '0.25';
gmt_azimuth1     = 45;
gmt_azimuth2     = 85;
gmt_graddifusion = 0.5;
gmt_dirrose      = '';
gmt_minwrap      = [];
gmt_maxwrap      = [];
gmt_outps        = [];
gmt_demgrd       = [];
gmt_colorn       = gmt_cptdb('egg');% cbcRd,egg,spectral,BlueWhiteOr
gmt_proj         = ' -JM4i ';
gmt_xoff         = '1i';
gmt_yoff         = '1i';
gmt_snew         = 'sNEW';
gmt_isov         = 0;
gmt_iscon        = 0;
gmt_demformat    = 'integer';
gmt_delgrd       = 1;
gmt_xtitle       = '';
gmt_ytitle       = '';
gmt_mul                = 1;
gmt_zinterv            = [];
gmt_unit               = [];
gmt_title              = '';
gmt_mregion            = [];
gmt_iscolorbar         = 1;
gmt_colorbardir        = 'h';
gmt_colorbarxtitle     = '';
gmt_colorbaryoffset    = '0.42i';
gmt_colorbarlength     = '1.5i';
gmt_colorbarxoffset    = '0.85i';
gmt_colorbarwidth      = '0.1i';
gmt_demdisplay         = '0.25 ';
gmt_gradientmethod     = 'A';     % A or E
gmt_lengthscale        = '';
gmt_lengthscaleframe   = 0.15;
gmt_colorbarannotangle = [];
gmt_factor             = [];
gmt_oversample         = [];
gmt_zerovalue          = [];
gmt_background         = [];
gmt_scalecof           = 1;                   % scale factor for DEM texture...
gmt_psscale_background_pen      = '0i';
gmt_psscale_background_fill     = [];
gmt_psscale_background_offset   = '0.01i';
gmt_psscale_background_offset_l = [];
gmt_psscale_background_offset_b = [];
gmt_psscale_background_offset_t = [];
gmt_psscale_background_offset_r = [];
gmt_transparency                = '0';
%
if isempty(MCM_rmspace(gmt_xtitle))
    gmt_xtitle = '';
end
if isempty(MCM_rmspace(gmt_ytitle))
    gmt_ytitle = '';
end
%%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
    %
end
%
if isempty(gmt_mregion)
    outregflag = 1;
else
    outregflag = 0;
end
%
%%
if isnumeric(gmt_zinterv)
    gmt_zinterv = num2str(gmt_zinterv);
end
%
[bp,bn,iext] = fileparts(imgfile);
outphsgrd    = fullfile(bp,[bn,'.grd']);
%
%
if gmt_delgrd==1
    if exist(outphsgrd,'file')
        delete(outphsgrd);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(gmt_outps)
    gmt_outps = fullfile(bp,[bn,'.ps']);
end
%
mtempfiles = cell(1);
ntemp      = 0;
%
if gmt_fillinnan == 1
    outname = [gmt_randname(5),'_R.img'];%'_tmpv1.img';
    sar_renan(imgfile,outname,gmt_inputformat,1);
    imgfile         = outname;
    gmt_inputformat = 'float';
    ntemp           = ntemp+1;
    mtempfiles{ntemp} = outname;
end
%
if isempty(gmt_factor)==0
    %
    outname = [gmt_randname(5),'_R.img'];%'_tmpv2.img';
    %imgfile
    sar_imgmath(imgfile,outname,gmt_factor,gmt_inputformat);
    imgfile = outname;
    ntemp   = ntemp+1;
    mtempfiles{ntemp} = outname;
    %
end
%
if isempty(gmt_zinterv)
    gmt_zinterv = num2str(abs(gmt_maxwrap));
end
%
%
disp(' GMT_Img2PS: Img2GRD');
if gmt_mul ~= 1
    %
    % Updated by FWP, @UoG, 2014-05-07
    tempfile = [gmt_randname(5),'_R.img'];
    gmt_img2grd(imgfile,outphsgrd,roi,gmt_inputformat,0,minwrap,maxwrap,gmt_scale,gmt_mul);%,outband);
    %
    %gmt_grdmath(outphsgrd,gmt_mul,'MUL',outphsgrd);
    gmt_grd2roi(outphsgrd,tempfile);
    gmt_img2grd(tempfile,outphsgrd,roi,gmt_inputformat,iswrap,minwrap,maxwrap,1,opvalue);%,1);
    %
    % Updated by FWP, @UoG, 2014-05-28
    % 
    [t_mp,bname] = fileparts(tempfile);
    ctemps = dir([bname,'.*']);
    for ntemp = 1:numel(ctemps)
        delete(ctemps(ntemp).name);
    end
    %
else
    %
    gmt_img2grd(imgfile,outphsgrd,roi,gmt_inputformat,iswrap,minwrap,maxwrap,gmt_scale,opvalue);%,outband);
end
%
if isempty(gmt_minwrap)==0 && isempty(gmt_maxwrap)==0
    %
    outgmt_cptname = [gmt_randname(5),'.cpt'];%'cor_temp.cpt';
    ntemp          = ntemp+1;
    mtempfiles{ntemp} = outgmt_cptname;
    if isempty(gmt_cptname)
        %
        gmt_makecpt(...
            'gmt_zstart',gmt_minwrap,...
            'gmt_zend',gmt_maxwrap,...
            'gmt_colorn',gmt_colorn,....
            'gmt_zinterv',num2str((gmt_maxwrap-gmt_minwrap)/128),...
            'gmt_cptname',outgmt_cptname);
    else
        gmt_makecpt(...
            'gmt_colorn',gmt_cptname,...
            'gmt_zstart',gmt_minwrap,...
            'gmt_zend',gmt_maxwrap,...
            'gmt_cptinput',gmt_cptname,....
            'gmt_zinterv',num2str((gmt_maxwrap-gmt_minwrap)/128),...
            'gmt_cptname',outgmt_cptname);
    end
    gmt_cptname = outgmt_cptname;
    % 
end

%
if ~isempty(gmt_oversample)
    %
    tempfile = [gmt_randname(5),'.img'];
    gmt_grdsample(outphsgrd,...
        'gmt_incscale',gmt_oversample,....
        'gmt_method','b',...
        'gmt_ggrd',tempfile);
    disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    movefile(tempfile,outphsgrd);
    %
end
%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(gmt_demgrd)==0
    % 
    tempfile = [gmt_randname(5),'_DEM.grd'];
    ntemp    = ntemp+1;
    mtempfiles{ntemp} = tempfile;
    %
    [t_mp,t_mp,fext] = fileparts(gmt_demgrd);
    if strcmpi(fext,'.grd') ~= 1
       %
       disp('   GMT_IMG2PS: grdcutdem(S)');
       gmt_grd2cutdem(outphsgrd,gmt_demgrd,tempfile,gmt_demformat);
       gmt_demgrd = tempfile;
       disp('   GMT_IMG2PS: grdcutdem(E)');
    else
       %
       demregion = gmt_grd2info(gmt_demgrd);
       roiregion = gmt_grd2info(outphsgrd);
       if sum(demregion == roiregion) < 4
           %
           type1 = sum([demregion(1);demregion(3)] <= [roiregion(1);roiregion(3)]);
           type2 = sum([demregion(2);demregion(4)] >= [roiregion(2);roiregion(4)]);
           if type1 < 2 || type2 < 2
               gmt_demgrd = [];
           else
               %gmt_grd2cutdem(grd,demfile,demgrd);
               gmt_grd2clipdem(gmt_demgrd,roiregion,outphsgrd,tempfile);
               gmt_demgrd = tempfile;
           end
       end
    end
end
%
disp(' GMT_IMG2PS: wrap');
%
if iswrap == 1
    gmt_e = ' ';
else
   gmt_e = ' -E ';
end
%

outregion  = gmt_grd2region(outphsgrd);
%
[gmt_mregion,psbasemapstr,colorbarstr] = gmt_grdimageadddem(outphsgrd,...
    'gmt_psbasemap',gmt_psbasemap,...
    'gmt_mregion',  gmt_mregion,...
    'gmt_proj',     gmt_proj,...
    'gmt_outps',    gmt_outps,...
    'gmt_demgrd',   gmt_demgrd,...
    'gmt_colorn',   gmt_colorn,...
    'gmt_mregion',  gmt_mregion,...
    'gmt_xoff',                       gmt_xoff,...
    'gmt_yoff',                       gmt_yoff,...
    'gmt_axstep',                     gmt_axstep,...
    'gmt_dirrose',                    gmt_dirrose,...
    'gmt_aystep',                     gmt_aystep,...
    'gmt_xtitle',                     gmt_xtitle,...
    'gmt_ytitle',                     gmt_ytitle,...
    'gmt_psscale_background_pen',     gmt_psscale_background_pen,...
    'gmt_psscale_background_fill',    gmt_psscale_background_fill,...
    'gmt_psscale_background_offset',  gmt_psscale_background_offset,...
    'gmt_psscale_background_offset_t',gmt_psscale_background_offset_t,...
    'gmt_psscale_background_offset_b',gmt_psscale_background_offset_b,...
    'gmt_psscale_background_offset_r',gmt_psscale_background_offset_r,...
    'gmt_psscale_background_offset_l',gmt_psscale_background_offset_l,...
    'gmt_snew',                       gmt_snew,...
    'gmt_azimuth1',                   gmt_azimuth1,...
    'gmt_azimuth2',                   gmt_azimuth2,...
    'gmt_gradientmethod',             gmt_gradientmethod,...
    'gmt_scalecof',                   gmt_scalecof,...
    'gmt_zerovalue',                  gmt_zerovalue,...
    'gmt_iskml',                      gmt_iskml,...
    'gmt_nanvalue',                   gmt_nanvalue,...
    'gmt_isov',                       gmt_isov,...
    'gmt_iscon',                      gmt_iscon,...
    'gmt_iscolorbar',                 gmt_iscolorbar,...
    'gmt_title',                      gmt_title,...
    'gmt_cptname',                    gmt_cptname,...
    'gmt_colorbardir',       gmt_colorbardir,...
    'gmt_colorbarxtitle',    gmt_colorbarxtitle,...
    'gmt_colorbaryoffset',   gmt_colorbaryoffset,...
    'gmt_colorbarlength',    gmt_colorbarlength,...
    'gmt_colorbarxoffset',   gmt_colorbarxoffset,...
    'gmt_colorbarwidth',     gmt_colorbarwidth,...
    'gmt_demdisplay',        gmt_demdisplay,...
    'gmt_graddifusion',      gmt_graddifusion,...
    'gmt_lengthscale',       gmt_lengthscale,...
    'gmt_colorbarannotangle',gmt_colorbarannotangle,...
    'gmt_lengthscaleframe',  gmt_lengthscaleframe,...
    'gmt_zinterv',           gmt_zinterv,...
    'gmt_unit',              gmt_unit,...
    'gmt_background',        gmt_background,...
    'gmt_transparency',      gmt_transparency,...
    'gmt_e',gmt_e);
%
% Delete temporary files...
% by FWP,@GU, 2014-05-07
for ni = 1:numel(mtempfiles)
    if exist(mtempfiles{ni},'file')
        [t_mp,bname] = fileparts(mtempfiles{ni});
        tempfiles = dir([bname,'.*']);
        %
        for nj = 1:numel(tempfiles)
            delete(tempfiles(nj).name);
        end
        % delete(mtempfiles{ni});
        %
    end
end
if outregflag == 0 
    %
    gmt_mregion = MCM_rmspace(gmt_mregion);
    temp      = textscan(gmt_mregion(3:end),'%f','delimiter','/');
    outregion = temp{1};
    outregion = outregion(:)';
    %outregion
end
