function gmt_gmtset(varargin)
%
% Gmt default settings
% Created by Feng, W.P., 10/10/2011, @UoG
% Updated by Feng, W.P., @ YJ, 2015-04-17
% this version should be working for GMT5.x...
% Updated y Feng, W.P., @ NRCan, 2015-10-07
% -> make this version to work for GMT5.x in Linux system...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_grid_cross_size_primary    = '0c';
gmt_grid_cross_size_secondary  = '0c';
gmt_input_date_format          = 'yyyy-mm-dd';
gmt_oblique_annotation         = '0';
gmt_color_model                = 'rgb';
gmt_version                    = 5;
gmt_paper_media                = 'A0';
gmt_frame_pen                  = '0.01c';
gmt_frame_width                = '0.05c';
gmt_annot_font_size_primary    = '10p';
gmt_annot_font_size_secondary  = '12p';
gmt_label_font_size            = '12p';
gmt_label_offset               ='0.1c';
gmt_header_offset              = '0.1c';
gmt_title_offset               = '10p';
gmt_header_font_size           = '10p';
gmt_annot_min_spacing          = '0.001c';
gmt_tick_length                = '0.05c';
%
gmt_tick_pen                = '0.1p';
gmt_basemap_type            = 'plain';
gmt_color_background        = '0/0/0';
gmt_color_foreground        = '255/255/255';%, COLOR_FOREGROUND
gmt_color_nan               = '255/255/255';
gmt_grid_cross_size_primary = '0p';
gmt_grid_pen_primary        = '0.25p';
gmt_annot_min_angle         = '0';
gmt_annot_offset_primary    = '0.2c';
gmt_annot_offset_secondary  = '0.1c';
gmt_map_scale_height        = '0.15c';
gmt_page_color              = '255/255/255';
gmt_transparency            = '0';
gmt_d_format                = '%9.2f';
gmt_font_title              = '15p,Helvetica,black';
%
%gmt_ANNOT_OFFSET_PRIMARY='0.001c';
%
mparas = {...
    'gmt_grid_cross_size_primary',...
    'gmt_grid_cross_size_secondary',...
    'gmt_oblique_annotation',....
    'gmt_color_model',...
    'gmt_paper_media',...
    'gmt_frame_pen',...
    'gmt_header_font_size',...
    'gmt_frame_width',...
    'gmt_annot_font_size_primary',...
    'gmt_label_font_size',...
    'gmt_label_offset',...
    'gmt_header_offset',...
    'gmt_annot_min_spacing',...
    'gmt_tick_length',...
    'gmt_tick_pen',...
    'gmt_basemap_type',...
    'gmt_color_background',...
    'gmt_color_foreground',...
    'gmt_color_nan',...
    'gmt_grid_cross_size_primary',...
    'gmt_grid_pen_primary',...
    'gmt_annot_min_angle',...
    'gmt_annot_offset_primary',...
    'gmt_map_scale_height',...
    'gmt_input_date_format',...
    'gmt_page_color',...
    'gmt_annot_offset_secondary',...
    'gmt_transparency',...
    'gmt_annot_font_size_secondary',...
    'gmt_d_format',...
    'gmt_font_title',...
    'gmt_title_offset',...
    'gmt_input_date_format'};
%
if gmt_version < 5
    %
    for ni = 1:2:nargin
        %
        para   = varargin{ni};
        para   = para(5:end);
        pvalue = varargin{ni+1};
        %
        if strcmpi(para,'VERSION')==0
            %
            disp(['gmtset ' para ' = ' pvalue]);
            system(['gmtset ' para ' = ' pvalue]);
        end
    end
    %
else
    % trying to suit GMT5 with previous innputs which were used for GMT4
    % by Feng, W.P., @GU, 2015-04-17
    %
    for ni = 1:2:nargin
        %
        inkeyword = varargin{ni};
        para      = upper(inkeyword(5:end));
        %
        % convert GMT4-keywords to GMT5-keywords
        if strcmpi(para,'PAPER_MEDIA')
            para = 'PS_MEDIA';
        end
        if strcmpi(para,'ANNOT_FONT_SIZE_PRIMARY')
            para = 'FONT_ANNOT_PRIMARY';
        end
        if strcmpi(para,'TICK_LENGTH')
            para = 'MAP_TICK_LENGTH_PRIMARY';
        end
        if strcmpi(para,'FRAME_WIDTH')
            para = 'MAP_FRAME_WIDTH';
        end
        if strcmpi(para,'OBLIQUE_ANNOTATION')
            para = 'MAP_ANNOT_OBLIQUE';
        end
        if strcmpi(para,'FRAME_WIDTH')
            para = 'MAP_FRAME_WIDTH';
        end
        if strcmpi(para,'BASEMAP_AXES')
            para = 'MAP_FRAME_AXES';
        end
        if strcmpi(para,'frame_pen')
            para = 'MAP_FRAME_PEN';
        end
        if strcmpi(para,'annot_offset_primary')
            para = 'MAP_ANNOT_OFFSET_PRIMARY';
        end
        if strcmpi(para,'label_font_size')
            para = 'FONT_LABEL';
        end
        if strcmpi(para,'label_offset')
            para = 'MAP_LABEL_OFFSET';
        end
        if strcmpi(para,'title_offset')
            para = 'MAP_TITLE_OFFSET';
        end
        if strcmpi(para,'input_date_format')
            para = 'FORMAT_DATE_IN';
        end
        %
        %
        %
        if strcmpi(para,'VERSION')==0
            pvalue = varargin{ni+1};
            %disp(pvalue)
            disp(['gmt gmtset ' para ' = ' pvalue]);
            system(['gmt gmtset ' para ' = ' pvalue]);
        end
    end
end
