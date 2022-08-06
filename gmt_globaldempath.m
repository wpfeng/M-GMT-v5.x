function gdempath = gmt_globaldempath(model)
%
%
%
%
% full path of the global dem in different resolution
% by fWP, @GU, 2014-07-22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin < 1
    disp('gdempath = gmt_globaldempath(model)');
    disp('************************************');
    disp('model: 5,10,20');
    disp('   5, etopo_5.grd');
    disp('  10, etopo_10.grd');
    disp('  20, etopo_20.grd');
    %
    return
end
switch model
    case 5
        gdempath = 'E:\DB\data\imag\etopo_5.grd';
    case 10
        gdempath = 'E:\DB\data\imag\etopo_10.grd';
        
    case 20
        gdempath = 'E:\DB\data\imag\etopo_20.grd';
end
