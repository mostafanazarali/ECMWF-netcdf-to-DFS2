% This code converts ECMWF ERA Interim wind field data (including 10 m u-wind velocity/ 10 m v-wind velocity/ Mean sea level pressure) from netcdf format to DHI MIKE dfs2 format
% Written by Mostafa Nazarali (2017-05-02)
% mostafa.nazarali@gmail.com

clear all;
clc

fn=dir('*.nc');
fname1=fn.name;
u=ncread(fname1,'u10');
v=ncread(fname1,'v10');
p=ncread(fname1,'msl');
lat=ncread(fname1,'latitude');
lon=ncread(fname1,'longitude');
t=ncread(fname1,'time');
t=datenum(1900,1,1,0,0,0)+double(t)/24;

fid=fopen('ECMWF.txt','wt');
% Titels
fprintf(fid,'"Title" "File Title"\n');
fprintf(fid,'"Dim" 2\n');
fprintf(fid,'"Geo" "LONG/LAT" %d %d 0\n',length(lon),length(lat));
fprintf(fid,'"Time" "EqudistantTimeAxis" "%s" "%s" %d %d\n',datestr(t(1),'yyyy-mm-dd'),datestr(t(1),'HH:MM:SS'),length(t),(t(2)-t(1))*24*3600);
fprintf(fid,'"NoGridPoints" %d %d\n',length(lon),length(lat));
fprintf(fid,'"Spacing" %g %g\n',abs(lon(2)-lon(1)),abs(lat(2)-lat(1)));
fprintf(fid,'"NoStaticItems" 0\n');
fprintf(fid,'"NoDynamicItems" 3\n');
fprintf(fid,'"Item" "MeanSeaLevelPressure" "Pressure" "Pascal"\n');
fprintf(fid,'"Item" "U-wind" "Wind Velocity" "m/s"\n');
fprintf(fid,'"Item" "V-wind" "Wind Velocity" "m/s"\n');
fprintf(fid,'NoCustomBlocks 1\n');
fprintf(fid,'"M21_Misc" 1 7 0 -1E-030 -900 -999 -1E-030 -1E-030 -1E-030\n');
fprintf(fid,'"Delete" -1E-030\n');
fprintf(fid,'"DataType" 0\n');
fprintf(fid,'\n');
for i=1:length(t)
    i
    fprintf(fid,'"tstep" %d "item" 1 "layer" 0\n',i-1);
    for j=1:length(lat)
        for k=1:length(lon)
            fprintf(fid,'%f ',(p(k,j,i)));
        end
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,'"tstep" %d "item" 2 "layer" 0\n',i-1);
    for j=1:length(lat)
        for k=1:length(lon)
            fprintf(fid,'%f ',(u(k,j,i)));
        end
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,'"tstep" %d "item" 3 "layer" 0\n',i-1);
    for j=1:length(lat)
        for k=1:length(lon)
            fprintf(fid,'%f ',(v(k,j,i)));
        end
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');    
end
fclose(fid);
