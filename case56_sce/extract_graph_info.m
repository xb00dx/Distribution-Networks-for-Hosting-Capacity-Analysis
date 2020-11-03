clear; clc; close all;

define_constants;
mpc = case56_sce;

nline = size(mpc.branch,1);
network = zeros(nline,4); % first two columns are the nodes, last two columns are weights

network(:,1:2) = mpc.branch(:,[F_BUS, T_BUS]);
network(:,3) = 1./mpc.branch(:,BR_X);
network(:,4) = 1./ sqrt( mpc.branch(:,BR_R).^2+mpc.branch(:,BR_X).^2 );

% writematrix(network,'.csv')