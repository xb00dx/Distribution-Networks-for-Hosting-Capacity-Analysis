clear; clc; close all;

define_constants;

dat_ori = readmatrix('R1-1247-2and4-balanced-phase.csv'); % hourly load data

num_node = size(dat_ori,2);

nday = 365; nt = 144; % 10-min resolution

dat = dat_ori ./ repmat(max(dat_ori,[],1), nday*24,1);

% num_node by 365 structure
% each (i,j) structure has a field MW with 144 points

mpc = loadcase('../case56_sce/case56_sce.m');

f_load = figure;
for in = 1:56
    for id = 1:nday 
    % reshape to 10-min based
    if id < nday
        ind = (id-1)*24 + (1:25);
    else
        ind = (id-1)*24 + (0:24);
    end
    x = (0:24);
    xq = (0:1/6:24);
    vq = interp1(x, dat(ind,in), xq);
    
    demand(in,id).normalized_load = vq(1:nt);
    demand(in,id).MW = vq(1:nt) * 1.5*mpc.bus(in,PD);
    plot(demand(in,id).normalized_load), hold on,
%     plot(xq, vq, '-o'), hold on,
%     legend('original','interpolation')
%     hold off
    % at every node
    
    end
    title(['node ',num2str(in)])
    xlabel('time (144 points)'), ylabel('normalized load (0-100%)')
    hold off
    print(f_load,'-dpng',['normalized_load_at_node_',num2str(in),'.png']);
%     clf
end

save('case56_sce_load.mat','demand');