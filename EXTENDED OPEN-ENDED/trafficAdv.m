%% EXTENDED COMPUTING PROJECT: TRAFFIC FLOW
% Harry Watson

close all
clear
clc

%% define initial variables

len = 1000; % number of sites
lanes = 5; % number of lanes (indexed from left to right)
lanereg = zeros(2,lanes);
% ^ keeps track of where data for different lanes begins and ends in main
% matrix, defined properly after carGenAdv runs
N = 100; % number of cars
V = 7; % 'speed limit' (mean max speed)
sigma = 1; % standard deviation of normal distribution of max speeds
p = 0.1; % probability of an individual car slowing each time step
spavg = zeros(1,lanes); % variable to keep track of average lane speeds

%% create and place stationary cars randomly on the road

car = carGenAdv(len,lanes,N,V,sigma);

% encode where each lane's data begins and ends in the car matrix
if lanes > 1
    lanereg = laneDex(lanereg,car);
end

% define max speed for graphing purposes
mx = max(car(:,4));

%% create figure window
global stopButtonValue

fig = figure('Position',[50 50 1500 700]); % figure window
fig.Name = 'Simulation of road traffic';
ax3 = axes('Position',[0.05 0.1 0.6 0.8]);
ax4 = axes('Position',[0.75 0.3 0.2 0.6]);
% ^ ax3 and ax4 are for labelling the plots. re-assigning labels and titles
% every iteration loop slowed the program down significantly. hence, these
% axes are created behind the ones being plotted on. the hidden axes are
% labelled, and these label the shown axes by proxy.
ax = axes('Position',[0.05 0.1 0.6 0.8]); % ax and ax2 are for plotting
ax2 = axes('Position',[0.75 0.3 0.2 0.6]);
plot(ax,car(:,2),car(:,1),'k.') % plot initial car pos.

% create a button that can exit the iteration loop without creating error
% messages
stopButtonValue = true;
stopButton = uicontrol('Style','togglebutton','Position',...
    [1300 75 100 50],'String','Close','callback',@toggleStop);

ylim(ax,[0 lanes+1])
xlim(ax,[1 len])
ylim(ax2,[0 mx+1])

title(ax3,'Road')
xlabel(ax3,'Site')
ylabel(ax3,'Lane')

title(ax4,'Average speed of lanes')
xlabel(ax4,'Lane')
ylabel(ax4,'Average speed')

% get rid of the axis value ticks on the background axes, but also push
% their labels out past the value ticks of the foreground axes. kind of a
% pain but that's MATLAB i suppose
ax3.YTickLabel = num2str('');
ax3.XTickLabel = num2str('');
ax4.YTickLabel = num2str('');
ax4.XTickLabel = num2str('');
xh3 = get(ax3,'xlabel');
yh3 = get(ax3,'ylabel');
xh4 = get(ax4,'xlabel');
yh4 = get(ax4,'ylabel');
px3 = get(xh3,'Position');
py3 = get(yh3,'Position');
px4 = get(xh4,'Position');
py4 = get(yh4,'Position');
px3(2) = px3(2)*4;
py3(1) = py3(1)*4;
px4(2) = px4(2)*4;
py4(1) = py4(1)*4;
set(xh3,'Position',px3) 
set(yh3,'Position',py3) 
set(xh4,'Position',px4) 
set(yh4,'Position',py4) 


%% update system

while stopButtonValue
    
    drawnow
    if ~stopButtonValue
        break % exit the loop when the close button is pressed
    end
    car = carTickAdv(car,len,lanereg,p,N,lanes); % run update function
    lanereg = laneDex(lanereg,car); % re-encode lane data markers
    spavg = carSpeed(spavg,car,lanereg,N); % calc. average speeds in lanes
    plot(ax,car(:,2),car(:,1),'k.') % plot the update
    bar(ax2,spavg) % blot a bar chart of average speeds in lanes
    ylim(ax,[0 lanes+1])
    xlim(ax,[1 len])
    ylim(ax2,[0 mx+1])
    pause(0.001)
    
end

close all
return


%% callback functions
function toggleStop(event,source) %#ok<INUSD>
global stopButtonValue
stopButtonValue = false;
end