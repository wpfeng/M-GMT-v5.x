function outvalue = gmt_defaults(inkeyword)
%
%
% created by FWP, @ GU, 2012-10-11
% Updated by Fwp, @ YJ, 2015-04-17
% -> make it suitable for GMT5.x
%
outvalue = [];
cgmt     = upper(inkeyword(5:end));
tempfile = [gmt_randname(5),'.info'];
%
% -L is deprecated, which has been in default in GMT5.x
%
% system(['gmtdefaults -L > ',tempfile]);
system(['gmt gmtdefaults > ',tempfile]);
fid = fopen(tempfile,'r');
while ~feof(fid)
    tline = fgetl(fid);
    if isempty(strfind(tline,cgmt))==0
        tmp = textscan(tline,'%s%s','delimiter','=');
        outvalue = tmp{2}{1};
    end
end
fclose(fid);
%
delete(tempfile);