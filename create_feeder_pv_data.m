clear; clc; close all;

data_path = './ca-pv-2006/original/';
capacities = [13; 75; 50; 38; 12; 12; 11; 13; 150; 44;...
              59; 8; 8; 13; 13; 44; 8; 8; 50; 8;...
              13; 13; 13; 125; 100; 44; 44; 5; 13; 13;...
              150; 80; 50; 5; 5; 13; 11; 50; 5; 5;...
              11; 11; 71; 71; 100; 50; 5; 11; 125; 71;...
              97; 71; 71; 74; 21; 150; 71; 11; 11; 31]; % california case 

% data_path = './tx-pv-2006/original/';
% capacities = [35; 35; 35; 27; 27; 37; 27;...
%     37; 37; 37; 37; 27; 27; 27; 28; 28; 28]; % texas case

files = dir(data_path);

nday = 365;
nt_original = 288; % 5 min data
nt = 144; % 10 min data
% nt = 24; % hourly data

pv_2006 = [];
pv_2006_mat = zeros(nday*nt, length(capacities));
f_profile = figure;
for i = 1:length(capacities)
    data_source = files(i+2).name;
    dat_original = readmatrix([data_path, data_source]);
    assert(size(dat_original,1) == nday*nt_original);
    raw = mean( reshape(dat_original(:,2), nt_original/nt,  nday*nt), 1 )'; % average of 2 points
    pv_2006_mat(:,i) = raw / capacities(i);
    pv_data = reshape(raw, nt, nday);
    pv_2006(i).source = data_source;
    pv_2006(i).info = 'normalized 5-min data (actual data / capacity), 365 days, NREL Solar Data, California 2006.';
%     pv_2006(i).info = 'normalized 5-min data (actual data / capacity), 365 days, NREL Solar Data, Texas 2006.';
    pv_2006(i).pv_actual_normalized = pv_data / capacities(i);
    pv_2006(i).pv_capacity = capacities(i);
    pv_2006(i).pv_actual = pv_data;
    
    daily_profile = reshape(pv_2006(i).pv_actual_normalized,nt,nday);
    plot(1:nt, daily_profile) 
    xlabel('time (144 points, 10-min resolution)')
    ylabel('normalized PV generation (0-100%)')
    title(data_source)
    
    print(f_profile,'-dpng',[data_source,'.png'])
end

save('ca-pv-2006.mat','pv_2006');
writematrix(pv_2006_mat, 'pv_ca_2006.csv');

% writematrix(pv_2006_mat, 'pv_ca_2006.csv');
