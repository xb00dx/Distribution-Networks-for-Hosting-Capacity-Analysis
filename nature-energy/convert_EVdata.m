clear; clc; close all;

% Original Data
EV1 = load('PEV-Profiles-L1.mat'); % level 1, slow charging
EV2 = load('PEV-Profiles-L2.mat'); % level 2, fast charging
% Load = load('Residential-Profiles.mat');

nEV = size(EV1.phevdata, 2); % 348 EVs
delta_t = 1/6;
nt = 24*6;
nDay = size(EV1.phevdata, 1)/nt; % Each EV has 365 scenarios (days)
% 
% info.readme = ['Create a Dataset for Small/Medium-Scale studies of EV Charging.',newline,...
%     'This dataset is created based on the Nature Energy Paper [1][2]',newline,...
%     'Charging interval: 144 10-minute interval in 24 hours, thus 144 points per day, 145 indicates 00:00 of the second day.',newline,...
%     'Fast Charging Rate: 6600 Watts; Slow Charging Rate: 1650 Watts.',newline,...
%     'EV Arrivals/Departures all happen at the beginning of each 10-min interval, and are in time indices, for example,',newline,...
%     'Arrival = 2 indicates EV arrives at 00:10',newline,...
%     'Departure = 145 indicates EV leaves at 00:00 of the second day',newline,...
%     'Demand is in MWh, time interval (delta_t) is 1/6 hour (10 minutes)',newline,...
%     '[1] Muratori, Matteo. 2018. "Impact of Uncoordinated Plug-in Electric Vehicle Charging on Residential Power Demand." Nature Energy 3 (3): 193-201.',newline,...
%     '[2] Muratori, Matteo. 2017. Impact of Uncoordinated Plug-in Electric Vehicle Charging on Residential Power Demand-Supplementary Data. National Renewable Energy Laboratory-Data (NREL-DATA).'];
% info.fast_charging = 1.65*4/1e3; % kW to MW
% info.slow_charging = 1.65/1e3; % kW to MW

info.readme = ['Create a Dataset for Small/Medium-Scale studies of EV Charging.',newline,...
    'This dataset is created based on the Nature Energy Paper [1][2]',newline,...
    'Charging interval: 144 10-minute interval in 24 hours, thus 144 points per day, 145 indicates 00:00 of the second day.',newline,...
    'Fast Charging Rate: 11.5 kW (max charging rate of Tesla Wall Connector); Slow Charging Rate (min charging rate of Tesla Wall Connector): 2.5 kW.',newline,...
    'EV Arrivals/Departures all happen at the beginning of each 10-min interval, and are in time indices, for example,',newline,...
    'Arrival = 2 indicates EV arrives at 00:10',newline,...
    'Departure = 145 indicates EV leaves at 00:00 of the second day',newline,...
    'Demand is in MWh, time interval (delta_t) is 1/6 hour (10 minutes)',newline,...
    '[1] Muratori, Matteo. 2018. "Impact of Uncoordinated Plug-in Electric Vehicle Charging on Residential Power Demand." Nature Energy 3 (3): 193-201.',newline,...
    '[2] Muratori, Matteo. 2017. Impact of Uncoordinated Plug-in Electric Vehicle Charging on Residential Power Demand-Supplementary Data. National Renewable Energy Laboratory-Data (NREL-DATA).'];
info.fast_charging = 11.5/1e3; % kW to MW, Tesla Wall connector max 115.kW
info.slow_charging = 2.5/1e3; % kW to MW, Tesla Wall connector min 115.kW
info.delta_t = delta_t;
info.nt = nt;
info.nDay = nDay;

disp(info.readme);


% Convert the EV Charging Data to tuples (arrival, departure, demand)
% Arrrival (time index): EV arrives at the beginning of this interval
% Departure (time index): EV leaves at the beginning of this interval
% Demand (kW): 
ind_max=  0;
max_demand = zeros(nEV*nDay,1);
for i = 1:nEV
for day = 1:nDay
    ind_max = ind_max + 1;
    indices = (1:nt) + (day-1)*nt;
    EV_data = EV1.phevdata(indices,i);
    M = 0; arrival = []; departure = [];
    was_charging = 0;
    for t = 1:nt
        if EV_data(t) > 1 % charging
            if (was_charging == 0) % begin charging
                M = M + 1;
                arrival = [arrival; t];
                was_charging = 1;
            end
            if t == nt % charging till the end of day
                departure = [departure; t+1]; % there is no next snapshot
            end
        else % not charging
            if (was_charging == 1) % just finish charging
                departure = [departure; t];
                was_charging = 0;
            end
        end
    end
    disp([num2str(M),' tasks for EV', num2str(i),' on day ',num2str(day)]);
    EVs(i, day).nJob = M;
    EVs(i, day).delta_t = delta_t; % hour, 10 minutes
    EVs(i, day).arrival = arrival;
    EVs(i, day).departure = departure;
    EVs(i, day).demand_MWh = (departure-arrival) * info.slow_charging * delta_t; % kWh to MWh
    EVs(i, day).max_charging_power = info.fast_charging;
    EVs(i, day).max_discharging_power = info.slow_charging;
    max_demand(ind_max) = sum( EVs(i, day).demand_MWh );
end
end

save('EVData-Arrival-Departure-Demand.mat','EVs','info');

%% More Notes: 
% charging rate in the original paper:
%   Slow Charging: 1.650 kW
%   Fast Charging: 6.600 kW
%  modified charging rate according to Tesla Wall Connector:
%   Slow Charging:  2.50 kW
%   Fast Charging: 11.50 kW