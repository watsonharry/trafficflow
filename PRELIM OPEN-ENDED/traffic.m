%% EXTENDED COMPUTING PROJECT: TRAFFIC FLOW
% Harry Watson

close all
clear
clc

%tic

%% define initial variables

I = 1000; % number of sites
N = 90; % number of cars
V = 7; % speed limit
T = 300; % time period to plot across
points = gobjects(1,T); % array to hold plotted data points
t = 0; % time
a = 1; % variable to index individual time-stepped plots
p = 0.3; % probability of an individual car slowing each time step

car = zeros(2,N); % car matrix. rows: site, velocity

%% place stationary cars randomly on the road

car(1,:) = carGen(I,N);

%% create figure window
global stopButtonValue

fig = figure('Position',[10 30 1000 700]); % figure window
ax = axes('Position',[0.1 0.1 0.75 0.85]); % axis
points(a) = plot(ax,car(1,:),repelem(t,N),'k.'); % plot initial car pos.

% create a button that can exit the iteration loop without creating error
% messages
stopButtonValue = true;
stopButton = uicontrol('Style','togglebutton','Position',...
    [875 75 100 50],'String','Close','callback',@toggleStop);

%% update system
t = 1;
a = 2;

hold on
while stopButtonValue
    while a <= T % cycles through indiv. plot indices to del. old plots
        drawnow
        if ~stopButtonValue
            break
        end
        car = carTick(car,I,V,p); % run the update function
        delete(points(a)) % delete the plot which was pushed off axis
        points(a) = plot(ax,car(1,:),repelem(t,N),'k.'); % plot the update
        ylim(ax,[t-T t]) % move along the y-axis with time
        t=t+1;
        a=a+1;
        xlabel('Site')
        ylabel('Time (timesteps or seconds)')
        %pause(0.01)
    end
    if ~stopButtonValue
            break
    end
    a = 1; % go back to the start of the graphics array
end

close all
return

%toc

%% callback functions
function toggleStop(event,source) %#ok<INUSD>
global stopButtonValue
stopButtonValue = false;
end