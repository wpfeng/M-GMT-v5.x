function gmt_img2grd_fixspatialsize(fimages,outname,roi,format,pixelsize)
%
% convert imagefile into grd file for gmt mapping
% Modification History:
% Created by Feng, W.P., 2011-08-31, @ BJ
% A new version for resampling image by a given spatial size...
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gmt_version
gmt_version = 4;
if nargin < 1
   disp('gmt_img2grd(fimages,outname,roi,format,iswrap,minwrap,maxwrap,scale)');
   return
end
if nargin < 4 || isempty(format)
    format = 'float';
end
if nargin < 5
    pixelsize = [];
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
iswrap  = 0;
minwrap = -3.14;
maxwrap = 3.14;
%
if nargin < 2 || isempty(outname)
    [bpath,bname] = fileparts(fimages);
    outname = fullfile(bpath,[bname,'.grd']);
end
scale = 1;
opvalue = 1;
%
%
[rscname,hdrname] = sim_imagecheckheader(fimages);
%
headerinfo        = [];
if isempty(hdrname)==0
    headerinfo = hdrname;
    headertype = 'hdr';
end
if isempty(rscname)==0
   headerinfo = rscname;
   headertype = 'rsc';
end
if isempty(headerinfo)==0
   %
   mroi = sar_header2roi(headerinfo,headertype);
   if nargin < 3 || isempty(roi)
       roi = mroi;
   end
   %
   %
   if isempty(rscname)
       sar_hdr2rsc(hdrname,[fimages,'.rsc']);
       %rscname = [fimages,'.rsc'];
   end
   %
   [data,~,~,info] = sim_defreadroi(fimages,format,scale,0,roi);
   %
   data = data.*opvalue;
   if iswrap==1
      %
      %
      disp([fimages,' is in rewrapping...']);
      data = sim_wrap(data,minwrap,maxwrap);
      %
      disp([fimages,' is ok!']);
   end
   %
   data(fix(data.*10^20)==0) = nan;
   sim_roi2ENVI(data,info,'FTEST.img','TEMP');
   mroi       = sar_header2roi('FTEST.img.rsc','rsc');
   info       = sim_roirsc('FTEST.img.rsc');
   %
   mregion    = ['-R' num2str(mroi(1),'%20.15f'),'/',num2str(mroi(1)+(info.width-1)*info.x_step,'%20.15f'),'/',num2str(mroi(3),'%20.15f'),'/',...
                      num2str(mroi(3)+(info.file_length-1)*abs(info.y_step),'%20.15f')];
   %
   switch upper(format)
       case 'FLOAT'
           if gmt_version < 5
              outformat = '-Zf';
           else
              outformat = '-ZTf';
           end
       case 'INTEGER'
           if gmt_version < 5
              outformat = '-Zh';
           else
              outformat = '-Zh';
           end
   end
   %
   strcommand = ['xyz2grd FTEST.img -G' outname ' -R0/' num2str(info.width-1),'/0/',num2str(info.file_length-1),' -I1/1 ',outformat];
   disp(strcommand);
   system(strcommand);
   if exist('FTEST.img','file')~=0
       delete FTEST.img*
   end
   grdeditstr = ['grdedit ',outname, ' ',mregion];
   disp(grdeditstr);
   system(grdeditstr);
   grd2xyz = ['grd2xyz ',outname,' -bo >> T.XYZ'];
   disp(grd2xyz);
   system(grd2xyz);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   gmt_mregion = [' -R',num2str(roi(1)),'/',num2str(roi(2)),'/',num2str(roi(3)),'/',num2str(roi(4))];
   if isempty(pixelsize)
      gmt_spacing = [' -I',num2str(info.x_step),'/',num2str(abs(info.y_step))];
   else
       if numel(pixelsize)==1
           pixelsize(2) = pixelsize(1);
       end
       %
      gmt_spacing = [' -I',num2str(pixelsize(1)),'/',num2str(abs(pixelsize(2)))];
   end
   strcommand = ['xyz2grd T.XYZ -bi -G' outname ' ',gmt_mregion,' ',gmt_spacing];
   disp(strcommand);
   system(strcommand);
   %
   delete('T.XYZ');%
   % 
else
    disp('There is not any proper header file found... ');
   return
end