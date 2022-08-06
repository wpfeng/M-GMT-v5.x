function gmt_img2grd(fimages,outname,roi,format,iswrap,minwrap,maxwrap,scale,opvalue)
%
% Convert imagefile, which has a .rsc header, into a grd  for gmt use
%
% Development History:
% Created by Feng, W.P., 2011-08-31, @ BJ
% Updated by Feng, W.P., @ YJ, 2015-04-17
% -> a new version can be used for GMT5.x...
% -> outband is deprecated, which is discarded in the latest version.
% Updated by Feng, W.P., @ NRCan, 2015-10-07
% -> make it available for GMT5.x in Linux
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gmt_version
gmt_version = 5;
if nargin < 1
   disp('gmt_img2grd(fimages,outname,roi,format,iswrap,minwrap,maxwrap,scale)');
   return
end
if nargin < 4 || isempty(format)
   format = 'float';
end
if nargin < 5 || isempty(iswrap)
   iswrap = 0;
end
if nargin < 6 || isempty(minwrap)
    minwrap = -3.14;
end
if nargin < 7 || isempty(maxwrap)
    maxwrap = 3.14;
end
%
if nargin < 2 || isempty(outname)
   [bpath,bname] = fileparts(fimages);
   outname = fullfile(bpath,[bname,'.grd']);
end
if nargin < 8
    scale = 1;
end
if nargin < 9
    opvalue = 1;
end
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
   mroi = sar_header2roi(headerinfo,headertype);
   if nargin <3 || isempty(roi)
       roi = mroi;
   end
   % 
   if isempty(rscname)
       sar_hdr2rsc(hdrname,[fimages,'.rsc']);
   end
   %
   [data,t_mp,t_mp,info] = sim_readimg(fimages,'datatype',format,...
                    'downsamplescale',scale,'isplot',0,'roi',roi);
   data            = data.*opvalue;
   if iswrap==1
      %
      data(data==0) = nan;
      %
      disp([ ' ',fimages,' is in rewrapping...']);
      %
      %
      data = sim_wrap(data,minwrap,maxwrap); 
      %
   end
   %
   data(data == 0) = nan;
   %
   tempfile = [gmt_randname(5),'_FT.img'];
   %
   sim_roi2ENVI(data,info,tempfile,'TEMP');
   mroi       = sar_header2roi([tempfile,'.rsc'],'rsc');
   info       = sim_roirsc([tempfile,'.rsc']);
   %
   mregion    = ['-R' num2str(mroi(1),'%20.15f'),'/',num2str(mroi(1)+(info.width-1)*info.x_step,'%20.15f'),'/',num2str(mroi(3),'%20.15f'),'/',...
                      num2str(mroi(3)+(info.file_length-1)*abs(info.y_step),'%20.15f')];
   %
   switch upper(format)
       case 'FLOAT'
           if gmt_version < 5
              outformat = '-Zf';
           else
              outformat = '-ZTLf';
           end
       case 'INTEGER'
           if gmt_version < 5
              outformat = '-Zh';
           else
              outformat = '-ZTLh';
           end
   end
   %
   strcommand = [' gmt xyz2grd ',tempfile,' -G' outname ' -R0/' num2str(info.width-1),'/0/',num2str(info.file_length-1),' -I1/1 ',outformat];
   disp(strcommand);
   system(strcommand);
   %
   if exist(tempfile,'file')
       delete(tempfile);
       delete([tempfile,'.hdr']);
       delete([tempfile,'.rsc']);
   end
   %
   if gmt_version == 5
       %
       grdeditstr = [' gmt grdedit ',outname, ' ',mregion,' -Vq'];
   else
       grdeditstr = [' grdedit ',outname, ' ',mregion];
   end
   disp(grdeditstr);
   system(grdeditstr);
   %
   % 
else
    disp(' There is not any proper header file found... ');
   return
end