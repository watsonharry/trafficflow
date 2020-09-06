%% EXTENDED COMPUTING PROJECT:
% TRAFFIC FLOW: Flow versus density script
% Harry Watson

close all
clear
clc

%% define initial variables
tic
len = 500; % number of sites
lanes = 5; % number of lanes (indexed from left to right)
lanereg = zeros(2,lanes);
% ^ keeps track of where data for different lanes begins and ends in main
% matrix, defined properly after carGenAdv runs
V = 7; % 'speed limit' (mean max speed)
sigma = 1; % standard deviation of normal distribution of max speeds
p = 0.3; % probability of an individual car slowing each time step
spavg = zeros(1,lanes); % variable to keep track of average lane speeds
T = 1000;
repeats = 3; % number of times to repeat (for error bars)
q = zeros(repeats,100);
err = zeros(lanes,100);
Q = err;

%% create figure window

fig = figure('Position',[100 200 1000 700]); % figure window
ax = axes('Position',[0.1 0.1 0.8 0.8]); % axis

%% flow vs. density data loop

hold on
for lane = 1:1:lanes
for repeat = 1:1:repeats

for ro = 1:1:100 % for density percentage 'cars per site' from 1% to 100%
ro
lane
repeat
% ^ keep track on the position in the program

% place stationary cars randomly on the road

N = (ro/100)*len;
car = carGenAdv(len,lane,N,V,sigma);
lanereg = zeros(2,lane);
lanereg = laneDex(lanereg,car);

% encode where each lane's data begins and ends in the car matrix
if lanes > 1
    lanereg = laneDex(lanereg,car);
end

% run the system for a while to get it out of its initial transience
for t = 0:1:T
    car = carTickAdv(car,len,lanereg,p,N,lane); % run the update function
    lanereg = laneDex(lanereg,car);
end

car(:,5) = zeros(N,1);

% now run the system a while longer, but record flow rate
for t = 0:1:T*10
    car = carTickAdv(car,len,lanereg,p,N,lane);
    lanereg = laneDex(lanereg,car);
end

q(repeat,ro) = sum(car(:,5))./T; % sum dist. travelled over period

end

end

for n = 1:1:100
    err(lane,n) = std(q(:,n));
    Q(lane,n) = mean(q(:,n));
end

errorbar(linspace(1,500,100),Q(lane,:),err(lane,:),'-')

xlabel('Number of cars')
ylabel('Flow q (cars per time step)')
end
toc
