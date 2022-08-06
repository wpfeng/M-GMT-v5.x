function gmt_global(roi,varargin)
%
%
% GMT plotting
% Feng, Wanpeng, @GU, 2011-11-08
%
if nargin < 1 || isempty(roi)
    roi  = [99.65,100.2,20.5,20.9];
end
gmt_outps   = 'test.ps';
gmt_isov    = 0;
gmt_iscon   = 0;
gmt_xoff    = '0i';
gmt_yoff    = '0i';
gmt_grid    = '1';
gmt_mapsize = '2i';
gmt_cptname = 'globe';
gmt_type    = 'vector';
gmt_cenlat  = [];
gmt_cenlon  = [];
gmt_demdisplay      = 0.5;
gmt_azimuth2        = 135;
gmt_azimuth1        = 45;
gmt_scalecof        = 1.2;
gmt_marktype        = 0;
gmt_globaltop       = gmt_globaldempath(10);%'E:\DB\data\imag\etopo_10.grd';
gmt_roiedgecolor    =',255/0/0';
gmt_linewidth       = '0.01c';
gmt_globalfillcolor ='200/200/200';
gmt_pointtype       = 't';
gmt_pointsize       = '0.04i';
gmt_pointcolor      = '255/0/0';
if nargin < 1
    disp('gmt_global(meanx,meany);');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
    %
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gmt_isov == 0
    type1 = ' >';
else
    type1 = ' -O >>';
end
if gmt_iscon == 0
    type2 = ' ';
else
    type2 = ' -K ';
end
%

%
lons  = roi(:,1:2);
lats  = roi(:,3:4);
if isempty(gmt_cenlon)
   %
   meanx = mean(lons(:));
else
   meanx = gmt_cenlon;
end
if isempty(gmt_cenlat)  
   meany = mean(lats(:));
else
   meany = gmt_cenlat;
end
%
gmt_gmtset('gmt_frame_width','0.00000001c',...
           'gmt_frame_pen',  '0.0001c');
%
gmt_isdem = 0;
switch upper(gmt_type)
    case 'VECTOR'
        c{1} = ['pscoast -Rg -JG' num2str(meanx) '/' num2str(meany) ...
            '/' gmt_mapsize ' -B' gmt_grid ' -Dh -A10000 -G' gmt_globalfillcolor ' -W0.2p,5/5/5 -P -K -X' gmt_xoff ' -Y' gmt_yoff type1 gmt_outps];
        
    otherwise
        %
        system(['makecpt -C' gmt_cptname ' > global.cpt']);
        cdem{1} = ['grdgradient ' gmt_globaltop ' -A' num2str(gmt_azimuth1) '/' num2str(gmt_azimuth2) ' ' ' -Ne' num2str(gmt_demdisplay) ' -V -Ggrad.grd'];
        cdem{2} = ['grdmath grad.grd ' num2str(gmt_scalecof) ' DIV = texture.grd'];
        cdem{3} = ['grdimage ' gmt_globaltop ' -Itexture.grd -Rg -JG' num2str(meanx) '/' num2str(meany) ...
            '/' gmt_mapsize ' -B' gmt_grid ' -Cglobal.cpt -P -K -X' gmt_xoff ' -Y' gmt_yoff type1 gmt_outps];
        
        c{1}    = cdem;
        gmt_isdem= 1;
end
step2 = cell(1);
for nj = 1:numel(roi(:,1))
    outname = ['lonlat-',num2str(nj),'.xy'];
    fid = fopen(outname,'w');
    if gmt_marktype == 0
        fprintf(fid,'%f %f \n',roi(nj,1),roi(nj,3));
        fprintf(fid,'%f %f \n',roi(nj,1),roi(nj,4));
        fprintf(fid,'%f %f \n',roi(nj,2),roi(nj,4));
        fprintf(fid,'%f %f \n',roi(nj,2),roi(nj,3));
        fprintf(fid,'%f %f \n',roi(nj,1),roi(nj,3));
    else
        clon = roi(nj,1:2);
        clat = roi(nj,3:4);
        fprintf(fid,'%f %f \n',mean(clon(:)),mean(clat(:)));
    end
    fclose(fid);
    gmt_isconstring = ' -K ';
    if nj == numel(roi(:,1));
        gmt_isconstring = ' ';
    end
    if gmt_marktype == 0
       step2{nj} = ['psxy ' outname '  -R -J ' gmt_isconstring ' -W' gmt_linewidth gmt_roiedgecolor ' ' type2 ' -O >> ' gmt_outps];
    else
        step2{nj} = ['psxy ' outname '  -R -J -W' gmt_linewidth gmt_roiedgecolor gmt_isconstring ' -S' gmt_pointtype gmt_pointsize ' -G' gmt_pointcolor ' -m ' type2 ' -O >> ' gmt_outps];
    end
end
c{2} = step2;
if gmt_iscon == 0
    c{3} = ['ps2raster ' gmt_outps ' -Tf -A -E300'];
else
    c{3} = '';
end
%
for ni =1:3
    if ni ==1 && gmt_isdem==1
        cdem = c{1};
        for nj = 1:numel(cdem);
            disp(cdem{nj});
            system(cdem{nj});
        end
    end
    if ni==1 && gmt_isdem==0
        disp(c{ni});
        system(c{ni});
    end
    if ni == 2
        ccom = c{2};
        for nj = 1:numel(ccom)
            disp(ccom{nj});
            system(ccom{nj});
        end
        %
        %
    end
    if ni == 3
        if ~isempty(c{ni})
            str = ['ps2raster ' gmt_outps ' -Tj -A -E720'];
            disp(str);
            system(str);
        end
        disp(c{ni});
        system(c{ni});
    end
end