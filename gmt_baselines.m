function [maxdates,mindate,maxvalue,minvalue] = gmt_baselines(basefile,varargin)
%
%
%
% Created by FWP, @ GU, 2013-08-31
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmt_tempbase = 360;
gmt_outps = 'baseline.ps';
gmt_iscon = 0;
gmt_isov  = 0;
gmt_psize = '0.2c';
gmt_ptype = 't';
gmt_xoff  = '2i';
gmt_yoff  = '2i';
gmt_snew  = 'SnEw';
gmt_proj  = ' -JX4i/2i ';
gmt_mregion = [];
gmt_maxvalue= [];
gmt_minvalue= [];
gmt_pfillc= '200/10/10';
gmt_xtitle= 'Date(YYYY/MM/DD)';
gmt_ytitle= 'PerpB(m)';
gmt_maxdate = [];
gmt_mindate = [];
gmt_bthreshold = 100;
gmt_xastep     = 'pa6Of1Og1O';
gmt_yastep     = '150';
gmt_timepoint2  = [];
gmt_timepoint1  = [];
gmt_timepoint3  = [];
% gmt_validpairs  = [];
%
%
if nargin < 1
    %
    basefile  = 'BASELINE_T083W.log';
end
%
v = sim_varmag(varargin);
for j = 1:length(v)
    eval(v{j});
end
%
threshold = gmt_bthreshold;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isplot    = 0;
data      = sar_baseline(basefile,isplot,threshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
system('gmtset INPUT_DATE_FORMAT yyyymmdd');
system('gmtset PLOT_DATE_FORMAT yyyy/mm/dd');
%

%
if isempty(gmt_mindate)
    mindate  = min(data(:,1));
else
    mindate = gmt_mindate;
end
if isempty(gmt_minvalue)
    minvalue = min(data(:,2))-150;
else
    minvalue = gmt_minvalue;
end
maxdate  = max(data(:,1));
if isempty(gmt_maxvalue)
    maxvalue = max(data(:,2))+150;
else
    maxvalue = gmt_maxvalue;
end
mindates = num2str(mindate);
%
if isempty(gmt_maxdate)
    maxdates = num2str(maxdate);
else
    maxdates = gmt_maxdate;
end
%
if isempty(gmt_mregion)
    gmt_mregion = [' -R',mindates(1,1:4),'-',mindates(1,5:6),'-',mindates(1,7:8),'T/',...
        maxdates(1,1:4),'-',maxdates(1,5:6),'-',maxdates(1,7:8),'T/',...
        num2str(minvalue),'/',num2str(maxvalue),' '];
end
%
%
gmt_psxy4points(data,...
    'gmt_outps',gmt_outps,...
    'gmt_proj',gmt_proj,...
    'gmt_mregion',gmt_mregion,...' -R20080901T/20100901T/-410/100 ',...
    'gmt_xoff',gmt_xoff,...
    'gmt_yoff',gmt_yoff,...
    'gmt_isov',gmt_isov,...
    'gmt_iscon',1,...
    'gmt_xastep',gmt_xastep,...
    'gmt_yastep',gmt_yastep,...
    'gmt_ptype',gmt_ptype,...
    'gmt_xtitle',gmt_xtitle,...
    'gmt_ytitle',gmt_ytitle,...
    'gmt_psize',gmt_psize,...
    'gmt_snew',gmt_snew,...
    'gmt_pfillc',gmt_pfillc);
%
alldata = load(basefile);
%
if ~exist('temp','dir')
    mkdir('temp');
end
%
tmpbaseline = 'temp/_tempb.inp';
fid = fopen('temp/_tempb.inp','w');
%
for ni = 1:numel(alldata(:,1))
    %
    dates = alldata(ni,1:2);
    n1    = datenum(num2str(dates(1)),'yyyymmdd');
    n2    = datenum(num2str(dates(2)),'yyyymmdd');
    if abs(alldata(ni,3)) <= threshold && n2-n1 <= gmt_tempbase
        index1 = data(:,1)==dates(1);
        index2 = data(:,1)==dates(2);
        cdata  = [dates(1),data(index1,2);...
            dates(2),data(index2,2)];
        %
        %
        fprintf(fid,'%s \n','>');
        fprintf(fid,'%d %d \n',cdata');
    end
end
fclose(fid);
%
npairs = 0;
if exist('insar_pairs.dat','file')
    cpairs = load('insar_pairs.dat');
    %
    %
    fidp = fopen('cpair.dat','w');
    for ni = 1:numel(alldata(:,1))
        %
        dates = alldata(ni,1:2);
        flag1 = cpairs(:,1) == dates(1);
        flag2 = cpairs(:,2) == dates(2);
        flag  = flag1+flag2;
        flag  = flag >= 2;
        if sum(flag)>0
            %
            index1 = data(:,1)==dates(1);
            index2 = data(:,1)==dates(2);
            npairs = npairs + 1;
            cdata  = [dates(1),data(index1,2);...
                dates(2),data(index2,2)];
            %
            %
            fprintf(fidp,'%s \n','>');
            fprintf(fidp,'%d %d \n',cdata');
        end
    end
    fclose(fidp);
    if (npairs==0)
        delete('cpair.dat');
    end
end
%
if isempty(gmt_timepoint1)~=1
    cdata = [fix(gmt_timepoint1),minvalue;fix(gmt_timepoint1),maxvalue];
    gmt_psxy4line(cdata,...
        'outps',gmt_outps,...
        'isov', 1,...
        'iscon',1,...
        'proj',' -J ',...
        'mregion', ' -R ',....
        'gmt_lwid','0.03c',...
        'linecolor',',200/0/0');
end
%
if isempty(gmt_timepoint2)~=1
    %[minvalue,maxvalue]
    cdata = [fix(gmt_timepoint2),minvalue;fix(gmt_timepoint2),maxvalue];
    %basefile
    gmt_psxy4line(cdata,...
        'outps',gmt_outps,...
        'isov', 1,...
        'iscon',1,...
        'proj',' -J ',...
        'mregion', ' -R ',....
        'gmt_lwid','0.03c',...
        'linecolor',',0/200/0');
end
%
if isempty(gmt_timepoint3)~=1
    %[minvalue,maxvalue]
    cdata = [fix(gmt_timepoint3),minvalue;fix(gmt_timepoint3),maxvalue];
    %basefile
    gmt_psxy4line(cdata,...
        'outps',gmt_outps,...
        'isov', 1,...
        'iscon',1,...
        'proj',' -J ',...
        'mregion', ' -R ',....
        'gmt_lwid','0.03c',...
        'linecolor',',0/0/250');
end
%
if npairs > 0
    gmt_psxy4line('cpair.dat',...
        'outps',gmt_outps,...
        'isov', 1,...
        'iscon',1,...
        'proj',' -J ',...
        'mregion', ' -R ',....
        'gmt_lwid','0.02c',...
        'linecolor',',100/100/100');
    delete('cpair.dat');
end
gmt_psxy4line(tmpbaseline,...
    'outps',gmt_outps,...
    'isov', 1,...
    'iscon',gmt_iscon,...
    'proj',' -J ',...
    'mregion', ' -R ',....
    'gmt_lwid','0.01c',...
    'linecolor',',100/100/100,--');


%

