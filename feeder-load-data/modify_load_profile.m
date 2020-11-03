clear; clc; close all;

dat2 = readmatrix('R1-1247-2.csv');
dat4 = readmatrix('R1-1247-4.csv');

oneph_ind2 = 1:251; threeph_ind2 = 252:3:290;
oneph_ind4 = 1:38; threeph_ind4 = 39:3:74;

nrow = 8760;
assert( size(dat2,1) == nrow );
assert( size(dat4,1) == nrow );

load_1ph = [dat2(:,oneph_ind2), dat4(:,oneph_ind4)];
load_3ph_2 = zeros(nrow,length(threeph_ind2));
for ic = 1:length(threeph_ind2)
    load_3ph_2(:,ic) = sum(dat2(:,threeph_ind2(ic):(threeph_ind2(ic)+2)),2);
end

load_3ph_4 = zeros(nrow,length(threeph_ind4));
for ic = 1:length(threeph_ind4)
    load_3ph_4(:,ic) = sum(dat4(:,threeph_ind4(ic):(threeph_ind4(ic)+2)),2);
end

dat_2and4 = [load_1ph, load_3ph_2, load_3ph_4 ];

writematrix(dat_2and4, 'R1-1247-2and4-balanced-phase.csv');