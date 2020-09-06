%% EXTENDED COMPUTING PROJECT:
% TRAFFIC FLOW: Flow versus density script

close all
clear
clc

%% define initial variables
I = 1000; % number of sites
V = 7; % speed limit
T = 10000; % time period to measure
p = 0.3; % probability of an individual car slowing each time step
repeats = 3; % number of repeats, for uncertainty analysis
q = zeros(repeats,100); % flow vs. density array

%% create figure window

fig = figure('Position',[100 200 1000 700]); % figure window
ax = axes('Position',[0.1 0.1 0.8 0.8]); % axis

%% flow vs. density data loop
for repeat = 1:1:repeats
for ro = 1:1:100 % for density percentage 'cars per site' from 1% to 100%
ro
N = round(I*(ro/100)); % number of cars
car = zeros(3,N); % car matrix. rows: site, velocity, number of wraps

% place stationary cars randomly on the road
car(1,:) = carGen(I,N);
car(2,:) = 0;

% run the system for a while to get it out of its initial transience
for t = 0:1:T
    car = carTick(car,I,V,p); % run the update function
end

% now run the system a while longer, but record flow rate
for t = 0:1:T
    car = carTickFlow(car,I,V,p); % sum dist. travelled over period
    q(repeat,ro) = sum(car(3,:))./T;
end

end

end

err = zeros(1,100);
Q = err;
for n = 1:1:100
    err(n) = std(q(:,n));
    Q(n) = mean(q(:,n));
end

errorbar(linspace(1,100,100),Q,err,'b*')

xlabel('Car density rho (%)')
ylabel('Flow q (cars per time step)')
title("Flow vs. density for I = "+num2str(I)+", V = "+num2str(V)+...
    ", p_{slow} = "+num2str(p)+", T = "+num2str(T))