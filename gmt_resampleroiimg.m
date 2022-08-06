function gmt_resampleroiimg(inphs,outphs,varargin)
%
%
%
%
% Developed by Feng, W.P., @YJ, 2015-05-04
%
% Initialling the parameters which could be used during resampling...
%
roi             = [];
format          = 'f';
downsamplescale = 1;
outsize         = [0.00083333,0.00083333];
gmt_method      = 'l';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
for ni = 1:2:numel(varargin)
    par = varargin{ni};
    val = varargin{ni+1};
    eval([par,'=val;']);
end
%
if exist('_tmp.grd','file')
   delete('_tmp.grd');
end
%
if strcmpi(format,'f')
    %
    gmt_img2grd(inphs,'_tmp.grd',roi,'float',[],[],[],downsamplescale);
else
    gmt_img2grd(inphs,'_tmp.grd',roi,'integer',[],[],[],downsamplescale);
end
%
gmt_outxsize = outsize(1);
gmt_outysize = outsize(2);
%
gmt_grdsample('_tmp.grd',...
    'gmt_ggrd','_tmp-RES.grd',...
    'gmt_outxsize',gmt_outxsize,...
    'gmt_outysize',gmt_outysize,...
    'gmt_method',gmt_method);
%
gmt_grd2roi('_tmp-RES.grd',outphs,format,[inphs,'.rsc']);
%
if exist('_tmp.grd','file')
    delete('_tmp.grd');
end
if exist('_tmp-RES.grd','file')
    delete('_tmp-RES.grd');
end
%