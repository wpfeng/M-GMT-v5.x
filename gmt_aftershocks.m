function gmt_aftershocks(infile,gmt_outps,varargin)
%
%
%
%
% Developed by Feng, W.P., @NRCan, 2015-11-26
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
gmt_pfillc       = '255/0/255';
gmt_linecolor    = ',200/200/200';
gmt_lwid         = '0.02c';
gmt_psize        = '';
gmt_ptype        = 'c';
gmt_mul          = 5;
gmt_iscon        = 1;
gmt_plotmodel    = 1;
gmt_cptname      = 'seis';
gmt_colordir     = 'h';
gmt_xshift       = '3i';
gmt_yshift       = '1.05i';
gmt_xlength      = '0.855i';
gmt_ywidth       = '0.085i';
gmt_bottomshift  = '0.065i';
gmt_xunit        = 'Aftershocks (USGS)';
gmt_yunit        = '(days)';
gmt_outdpi       = '300';

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load(infile);
%
switch gmt_plotmodel
    case 1
        cdata      = data(:,[2,3,5]);
        cdata(:,3) = cdata(:,3)./gmt_mul;
        gmt_psxy4points(cdata,...
            'gmt_outps',    gmt_outps,...
            'gmt_proj',     ' -J ',...
            'gmt_isov',     1,...
            'gmt_iscon',    gmt_iscon,...
            'gmt_ptype',    gmt_ptype,...
            'gmt_pfillc',   gmt_pfillc,...
            'gmt_linecolor',gmt_linecolor,...
            'gmt_psize',    gmt_psize,...
            'gmt_lwid',     gmt_lwid);
        %
    case 2
        cdata       = data(:,[2,3,1,5]);
        cdata(:,4)  = cdata(:,4)./gmt_mul;
        cdata(:,3)  = cdata(:,3)-min(cdata(:,3));
        %
        gmt_makecpt(...
            'gmt_colorn',  gmt_cptname,...
            'gmt_zstart',  0,...
            'gmt_zend',    max(cdata(:,3)),...
            'gmt_zinterv', max(cdata(:,3))./50,...
            'gmt_cptname', 'delaydays.cpt');
        %
        gmt_slipinterval = num2str(fix(max(cdata(:,3))./4));
        %
        
        %
        gmt_psxy4points(cdata,...
            'gmt_outps',    gmt_outps,...
            'gmt_proj',     ' -J ',...
            'gmt_isov',     1,...
            'gmt_iscon',    1,...
            'gmt_ptype',    gmt_ptype,...
            'gmt_fillcolor',' -Cdelaydays.cpt ',...
            'gmt_pfillc',   '',...
            'gmt_linecolor',gmt_linecolor,...
            'gmt_psize',    gmt_psize,...
            'gmt_lwid',     gmt_lwid);
        
        if gmt_iscon == 0
            gmt_iscons = ' ';
        else
            gmt_iscons = ' -K ';
        end
        %
        psscale = [' gmt psscale -Cdelaydays.cpt',' -D',gmt_xshift,'/',gmt_yshift,'',...
                   '/',gmt_xlength,'/',gmt_ywidth,gmt_colordir,' ',...
                   '-Tp+0.03i+g220/220/220+l0.0850i+r0.0350i+t0.0250i+b',gmt_bottomshift,'',' ',...
                   '-B',gmt_slipinterval,':"',gmt_xunit,'":/:"',gmt_yunit,'":  ',gmt_iscons,'  -O   >>',...
                   gmt_outps];
        disp(psscale);
        system(psscale);
        if gmt_iscon==0
           disp(['gmt psconvert ' gmt_outps ' -A -Tj  -E1100']);
           system(['gmt psconvert ' gmt_outps ' -A -Tj  -E' gmt_outdpi]);
           disp(['gmt psconvert ' gmt_outps ' -A -Tf  -E960']);
           system(['gmt psconvert ' gmt_outps ' -A -Tf  -E' gmt_outdpi]);
        end
end
