function outregion = gmt_oksar2depthprof(oksars,usgslocs,gmt_outps,varargin)
%
%figlable   = '(a) 2003';%{'2003','2003','2009'};
%
wraprange     = 2;
gmt_labelb    = '(b)';
gmt_lablesize = '6';
gmt_velsamp   = 3;
gmt_velthresh = 0.1;
gmt_isov      = 0;
gmt_iscon     = 0;
gmt_eqmag     = [];
gmt_xoff      = '2i';
gmt_yoff      = '2i';
gmt_isvel     = 1;
gmt_bxtitle   = 'Accumulated Moment along Strike (10@+17@+ N.m)';
gmt_isbplot   = 1;
gmt_iscontour = 0;
gmt_conwid    = '0.05p';
gmt_topunit   = '(m)';
gmt_snew      = 'SnEw';
gmt_slipmodel = 'syn';
gmt_istop     = 1;
gmt_slipmin   = 0;
gmt_slipmax   = 2;
gmt_outregion = [];
gmt_concolor  = ',100/100/100';
gmt_constart  = 0.1;
gmt_conend    = 2;
gmt_coninv    = 0.1;
gmt_cptname   = [];
gmt_width     = '2i';
gmt_height    = '0.8i';
gmt_fillcolor = '/128/128/158';
gmt_momentscale = 10^17;
gmt_xstep       = '2';
gmt_ystep       = '5';
gmt_zvalue      = '0';
gmt_bmregion    = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zone         = sim_oksar2utm(oksars);
[x,y] = deg2utm(usgslocs(1,2),usgslocs(1,1),zone);
%
outgrd = '2003.grd';
outroi = '2003.ImG';
gmt_oksar2grd(oksars,'2003.grd',0,gmt_slipmodel,'xy',[x,0]./1000);
gmt_grd2roi(outgrd,outroi,'f');
%
flag = 0;
if isempty(gmt_cptname)
    gmt_cptname  = gmt_cptdb('slipm');
    flag = 1;
end
%
if exist(gmt_cptname,'file')
    colormapt     = gmt_importcpt(gmt_cptname);
else
    colormapt = [];
end
if ~isnan(colormapt)
    %
    if flag==0
        foregroundcol = fix(colormapt(2,:).*255);
        backgroundcol = fix(colormapt(end-1,:).*255);
    else
        backgroundcol = fix(colormapt(2,:).*255);
        foregroundcol = fix(colormapt(end-1,:).*255);
    end
    backcol = [num2str(backgroundcol(1)),'/',...
        num2str(backgroundcol(2)),'/',...
        num2str(backgroundcol(3))];
    %
    forecol = [num2str(foregroundcol(1)),'/',...
        num2str(foregroundcol(2)),'/',...
        num2str(foregroundcol(3))];
else
    backcol = '0/0/0';
    forecol = '255/255/255';
end
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gmt_isbplot == 1
    [data,~,y,info] = sim_defreadroi(outroi,'float',1,0);
    s    = abs(info.x_step.*info.y_step)*10^6; % m^2
    mu   = 3.23e10;
    data = data.*mu.*s;
    mo   = sum(data')./gmt_momentscale;
    deps = y(:,1)';%linspace(info.y_first,info.y_step*numel(mo)+info.y_first,numel(mo));
    %
    mo   = [0,mo,0,0];
    deps = [deps(1),deps,deps(end),deps(1)];
    %
    if isempty(gmt_bmregion)
        gmt_bmregion = [' -R',num2str(min(mo)),'/',num2str(max(mo)),'/',...
            num2str(0),'/',num2str(max(deps(:))+2)];
        %
    end
    gmt_psxy4polygon([mo',deps'],...
        'gmt_proj',    [' -JX',gmt_height,'/-',gmt_height,''],...0.8i',...
        'gmt_mregion', gmt_bmregion,...
        'gmt_isov',  gmt_isov,....
        'gmt_iscon', 1,...
        'gmt_xoff',  gmt_xoff,...
        'gmt_yoff',  gmt_yoff,...
        'gmt_snew',  gmt_snew,...
        'gmt_xtitle', gmt_bxtitle,...
        'gmt_ytitle', 'Depth (km)',...
        'gmt_axoff', gmt_xstep,...'2',...
        'gmt_zvalue',gmt_zvalue,...
        'gmt_ayoff', gmt_ystep,...'5',...
        'gmt_fillcolor',gmt_fillcolor,...
        'gmt_outps',  gmt_outps);%varargin
    %
    
    if isempty(gmt_eqmag)
        gmt_eqmag = 2/3*log10(sum(mo).*10^17)-6.0333;
    end
    %
    outregion = [min(mo),max(mo),0,max(deps(:))+2];
    %
    %
    gmt_pstext(...
        'text_x',         num2str(min(mo)+0.01*(max(mo)-min(mo))),...
        'text_y',     num2str(outregion(3)+0.09*(outregion(4)-outregion(3))),...
        'text_string',gmt_labelb,...
        'text_size',  gmt_lablesize,...
        'text_isov',  1,...
        'text_iscon', gmt_iscon,...
        'text_outps', gmt_outps);
end