%
%
% Plot multiple slip models together...
% Developed by FWP, @ GU, 20120808
% Sorted by FWP, @GU, 20130403
%
gmt_outps = 'Final_Models_v2_20130403.ps';
oksars    = {'gps_inv_cgls.oksar','grace_inv_cgls.oksar',...
             'GG_inv_cgls.oksar'};
%%
gmt_gmtset(...
    'gmt_paper_media','A0',...
    'gmt_label_font_size','10p',...
    'gmt_annot_font_size_primary','8p')
%
numraw    = 1;
numcol    = 3;
gmt_resample = 0.05;
xwidth    = 6.0;
yheight   = 0.8;
gmt_proj  = ' -JX6.0i/0.8i ';
vconmax   = 60;
conzinterv= 20;
vmax      = 60;
czinterv  = '20';
cyoffset  = '0.8i';
endnum    = numel(oksars);
%
for ni = 1:endnum
    %
    %
    [~,bname] = fileparts(oksars{ni});
    %tmp       = textscan(bname,'%s %s','delimiter','-');
    stitle    = bname;%tmp{2}{1};
    %
    [gmt_xoff,gmt_yoff,gmt_iscon,gmt_isov] = ...
        gmt_sortplot(numraw,numcol,ni,xwidth,yheight);
    if ni == endnum
        gmt_iscon = 0;
    end
    gmt_oksar2slip(...
        'gmt_proj',gmt_proj,...
        'oksar',      oksars{ni},...
        'usgsloc',    [142.369,38.322,32],...
        'gmt_outps',  gmt_outps,...
        'vconmax',vconmax,...
        'gmt_resample',gmt_resample,...
        'vmax',vmax,...
        'xpatchsize', 20,...
        'ypatchsize', 4,...
        'conzinterv',conzinterv,...
        'gmt_uybound',0,...
        'gmt_lybound',-45,...
        'czinterv',czinterv,...
        'gmt_uxbound',250,...
        'gmt_lxbound',-200,...
        'gmt_velout','-N',...
        'gmt_velscale','0.02',...
        'gmt_iscon',gmt_iscon,...
        'gmt_isov',gmt_isov,...
        'gmt_xoff',gmt_xoff,...
        'gmt_yoff',gmt_yoff,...
        'gmt_method','n',...
        'gmt_figlable',upper(stitle));
    %
    
    %
end
