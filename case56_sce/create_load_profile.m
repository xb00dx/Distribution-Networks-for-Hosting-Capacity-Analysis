clear; clc; close all;

load('Residential-Profiles-TimeSeries.mat');

nt = 144; nday = 365;
load1 = reshape(sum(loaddata(:,1:100),2)*1, nt, nday);
load2 = reshape(sum(loaddata(:,100:200),2)*1, nt, nday);
for i = 1:nday
    demand(1,i).MW = load1(:,i) / 1e6; % W to MW
    demand(2,i).MW = load2(:,i) / 1e6; % W to MW
end

save('LoadProfile.mat','demand');