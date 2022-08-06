function outcpt = gmt_cptdb(iname,model)
%
% Developed by FWP,@GU,2012/01/01
% The specific colour table can be quickly picked up from the CPT database.
% 
% Updated by FWP,@GU, 2014-08-22
% a new keyword, model is provided. if model is "matlab", the colour table
% matrix will be output
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    %
    model = 'gmt';
end
%
% switch to Linux system...
%
if ~isempty(strfind(computer,'WIN'))
    odir = 'D:\mdbase\others\gmt_mcodesv5\cpt\';
else
    odir = '/home/wafeng/Programs/mdbase/others/gmt_mcodesv5/cpt/';
end
%
cfile = dir([odir,'/*',iname,'*.cpt']);
if numel(cfile)>0
    outcpt = [odir,'/',cfile(1).name];
else
    outcpt = [];
    disp(['No such file is found. Check the input again!!!']);
end
%
switch upper(model)
    case 'MATLAB'
        outcpt = gmt_importcpt(outcpt);
end
%
