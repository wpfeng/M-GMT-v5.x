function gmt_cutimgbyanother(inimage,reimage,outimage,ismask,informat,outformat)
%
%
%
%
% By FWP, @UoG, 2014-04-13
% Clip a subdataset based on spatial information of given images
%
%%%%%%%
%
if nargin < 1
    disp('gmt_cutimgbyanother(inimage,reimage,outimage,ismask,informat,outformat)');
    return
end
if nargin < 4
    ismask = 0;
end
if nargin < 5
    informat = 'float';
end
if nargin < 6
    outformat = informat;
end
%
%
gmt_img2grd(reimage,'Test.GRD',[],informat,0);%
% 
gmt_grd2cutdem('Test.GRD',inimage,'ImgN.GRD',outformat);
if strcmpi(outformat,'float')
   oformat = 'f';
else
   oformat = 'h';
end
%
gmt_grd2roi('ImgN.GRD',outimage,oformat,[inimage,'.rsc']);
%
if ismask == 1
   %disp(reimage);
   data = sim_defreadroi(reimage,'float',1);
   [data2,t_mp,t_mp,info] = sim_defreadroi(outimage,'float',1);
   data2(data==0) = 0;
   data2(isnan(data)) = 0;
   %
   sim_roi2ENVI(data2,info,outimage);
end
%