function mpc = case3_dist
%CASE3_DIST  Power flow data for 3 bus radial distribution system
%   modified system of case4_dist, by removing bus 4
%   Please see CASEFORMAT for details on the case file format.

%   MATPOWER

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
mpc.baseMVA = 1;

%% bus data
% bus_i  type  Pd  Qd  Gs  Bs  area  Vm  Va  baseKV  zone  Vmax  Vmin
mpc.bus = [
  1  1  0.2000  0.2000  0.0000  0.0000  1  1  0  12.5  1  1.05  0.95
  2  1  0.2000  0.2000  0.0000  0.0000  1  1  0  12.5  1  1.05  0.95
  3  3  0       0  0.0000  0.0000  1  1  0  12.5  1  1.05  0.95
];

%% generator data
% bus  Pg  Qg  Qmax  Qmin Vg  mBase  status  Pmax  Pmin  Pc1  Pc2  Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc  ramp_10  ramp_30  ramp_q  apf
mpc.gen = [
3  0.0000  0.0000  0.8  -0.8  1.0500  1  1   0.8  -0.8  0  0  0  0  0  0  0  0  0  0  0
];

%% branch data
% fbus  tbus  r  x  b  rateA  rateB  rateC  ratio  angle  status  angmin  angmax
% mpc.branch = [
%    1   2  0.003  0.006  0.000  999  999  999  0     0  1  -360  360
%  400   1  0.003  0.006  0.000  999  999  999  1.025 0  1  -360  360
% ];
%% (r and x specified in ohms here, converted to p.u. below)
% fbus  tbus  r  x  b  rateA  rateB  rateC  ratio  angle  status  angmin  angmax
% mpc.branch = [
% 	3	1	0.0922	0.0470	0	0.65	0	0	0	0	1	-360	360;
% 	1	2	0.4930	0.2511	0	0.5	0	0	0	0	1	-360	360;    
% ];

mpc.branch = [
	3	1	0.3922	0.2470	0	0.8	0	0	0	0	1	-360	360;
	1	2	0.4930	0.2511	0	0.4	0	0	0	0	1	-360	360;    
];

% [PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
%     VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
% [F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
%     TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
%     ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
define_constants;
Vbase = mpc.bus(1, BASE_KV) * 1e3;      %% in Volts
Sbase = mpc.baseMVA * 1e6;              %% in VA
mpc.branch(:, [BR_R BR_X]) = mpc.branch(:, [BR_R BR_X]) / (Vbase^2 / Sbase);

% % 3-dim matrix: nl-nt-N
% % nl: #loads; nt: #snapshots; N:#scenarios
% nt = 24*6; % 1 point per 10 minutes
% N = 365; % 365 scenarios/days
% load('Residential-Profiles.mat'); % get 52560*200 matrix

% mpc.load = zeros(2,nt,N);
% mpc.load(1,:,:) = reshape(sum(loaddata(:,1:100),2),nt,N) / 1e6; % W to MW
% mpc.load(2,:,:) = reshape(sum(loaddata(:,101:200),2),nt,N) / 1e6; % W to MW