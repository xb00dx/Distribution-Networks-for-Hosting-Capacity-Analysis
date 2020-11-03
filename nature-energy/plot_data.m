clear; close all;

EV1 = load('PEV-Profiles-L1.mat');
EV2 = load('PEV-Profiles-L2.mat');
Load = load('Residential-Profiles.mat');

nLoad = size(Load.loaddata,2);
nEV = size(EV1.phevdata, 2);

delta_t = 1/6;
nt = 24*6; % 1 point per 10 min
nDay=365;
total_load = reshape(sum(Load.loaddata,2),nt,nDay) / 10^3; % W -> kW

f_ev12 = figure;
for day = 1:nDay
    for i = 1:nEV
        ind = (1:nt)+(day-1)*nt;
        stairs(1:nt,EV1.phevdata(ind,i)), hold on,
        stairs(1:nt,EV2.phevdata(ind,i)), hold on,
        hold off
    end
end

f_ev1 = figure;
for i = 1:nEV
    ev_charging = reshape(EV1.phevdata(:,i), nt, nDay);
    plot(0:delta_t:(24-delta_t), sum(ev_charging,2))
    xlabel('time (24 hours)'), ylabel('EV Charging Power (W)')
end

f_load = figure;
plot(0:delta_t:(24-delta_t),total_load)
xlabel('time (24 hours)'), ylabel('load (kW)')
print(f_load,'-dpng','total-load-profile.png')