function gmt_inlocation(infile,varargin)
%
%
%
% plot station name with the symbol...
% 
% Created by FWP, @ GCU, 2013-08-26
%
gmt_proj    = ' -J ';
gmt_outps   = 'test.ps';
gmt_mregion = ' -R ';
gmt_isov    = 1;
gmt_iscon   = 1;
gmt_xshiftf = 0.1;
gmt_yshiftf = 0.1;
gmt_textsize= '15';
gmt_psize   = '0.1c';
gmt_pfillc  = '0/0/0';
gmt_inroi   = [];
gmt_ptype   = 't';
gmt_istext  = 1;

%
%
%%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%%
fid = fopen(infile,'r');
while ~feof(fid)
    tline = fgetl(fid);
    tmp   = textscan(tline,'%f %f %s');
    lon   = tmp{1};
    lat   = tmp{2};
    sta   = tmp{3}{1};
    %disp(sta);
    %
    if ~isempty(gmt_inroi)
        roi = gmt_inroi;
        inset = inpolygon(lon,lat,[roi(1),roi(1),roi(2),roi(2),roi(1)],....
                                  [roi(3),roi(4),roi(4),roi(3),roi(3)]);
    else
        inset = 1;
    end
    if inset == 1
        gmt_psxy4points([lon,lat],...
            'gmt_outps',gmt_outps,...
            'gmt_iscon',1,...
            'gmt_isov',1,...
            'gmt_psize',gmt_psize,...
            'gmt_pfillc',gmt_pfillc,...
            'gmt_proj',gmt_proj,....
            'gmt_ptype',gmt_ptype,...
            'gmt_mregion',gmt_mregion);
        if gmt_istext == 1
           gmt_pstext(...
               'text_x',num2str(lon+gmt_xshiftf),...
               'text_y',num2str(lat+gmt_yshiftf),...
               'text_string',sta,...
               'text_outps',gmt_outps,...
               'text_icon',1,...
               'text_size',gmt_textsize,....
               'text_isov',1);
        end
    end
    
    %
end
fclose(fid);
