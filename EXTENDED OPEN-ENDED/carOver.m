function ret = carOver(car,len,lanereg,dex)

% assign a variable for the lane the driver is in (for readability of code)
lane = car(dex,1);

% determine whether driver is at the 'front' of their lane
final = dex == lanereg(2,lane);

% based on this, identify the car they could be considering overtaking
if final == 0
    dex2 = dex + 1;
else
    dex2 = lanereg(1,lane);
end

% check if 'upset' about being behind the car they are behind
upset = car(dex,4) > car(dex2,4) &&...
    car(dex2,2) + final*len - car(dex,2) <= 10;
% ^ drivers become 'upset' if 10 or less sites behind a car with lower max
% speed

if car(dex,6) == 0 || upset == 1
% ^ bypass the rest of this function if the car doesn't want to move left
% or right
    
%% attempt to move right
                                 
    if car(dex,1) ~= 1 && car(dex,1) ~= 2 && upset == 1
    % ^ isn't in the right-most lane, nor second to right-most, is upset
        
        if lanereg(1,lane-1) ~= size(car,1) + 1 ...
                && lanereg(1,lane-2) ~= size(car,1) + 1
    % ^ if neither the lane to the right or the one to the right of that
    % are empty (explained more further down)
            
            R = round(mean(car(lanereg(1,lane-1):lanereg(2,lane-1),3))/2);
    % ^ adjust cautiousness (free space needed) entering lane based on the
    % average speed of cars in that lane. this is to stop reckless
    % overtaking that will cause other cars to 'slam on the brakes'
            
            rang = car(dex,2)-R:1:car(dex,2)+R;
            rang = rang + len.*double(rang <= 0);
    % ^ define the sites that must be free in the desired lane for the lane
    % change to take place
            
            move = zeros(2,length(rang));
            move(1,:) = ismember(rang,...
                car(lanereg(1,lane-1):lanereg(2,lane-1),2));
    % ^ check whether the desired free sites are free in the lane that is
            % wanted to change into
            move(2,:) = ismember(rang,...
                car(lanereg(1,lane-2):lanereg(2,lane-2),2));
    % ^ lane indexing is not updated until all cars have gone through the
    % overtaking algorithm. therefore, each car is making its decisions
    % based on how every other car was at the *start* of the timestep. to
    % ensure there are no collisions caused by two cars changing into the
    % same lane, cars moving right give priority to cars moving left. i.e.,
    % they need their 'safe overtaking zone' to be free in both the lane
    % they want to change into, and the lane to the right of that, which
    % could contain cars moving left. this check is not performed in the
    % second to rightmost lane, as it would result in checking lane 0,
    % which doesn't exist.
            
            move = double(~ismember(true,move));
            
        elseif (lanereg(1,lane-1) == size(car,1) + 1 ...
                || lanereg(1,lane-2) == size(car,1) + 1) ...
                && lanereg(1,lane-1) ~= lanereg(1,lane-2)
            % ^ if exactly one of the lanes on the right is empty
            
            lane2 = find(lanereg(1,lane-2:lane-1) == size(car,1) + 1);
            % ^ identify which lane is empty
            
            if lane2 == 2
                lane2 = lane - 2;
            else
                lane2 = lane - 1;
            end
            % ^ replace ID of empty with ID of not-empty
            
            R = round(mean(car(lanereg(1,lane2):lanereg(2,lane2),3))/2);
            % ^ adjust cautiousness based on traffic in non-empty lane
            
            rang = car(dex,2)-R:1:car(dex,2)+R;
            rang = rang + len.*double(rang <= 0);
            
            move = zeros(2,length(rang));
            move(1,:) = ismember(rang,...
                car(lanereg(1,lane2):lanereg(2,lane2),2));
            
            move = double(~ismember(true,move));
            
        else % if both are empty
            
            move = 1;
            
        end
        
        car(dex,1) = car(dex,1) - move;
        % ^ move into the lane on the right if the entry zone or lane is
        % empty
        
        car(dex,6) = 75*move;
        % ^ if the lane change occurs, set a cooldown that must tick down
        % before a lane change is attempted again
        
    elseif car(dex,1) == 2 && upset == 1
        % ^ if looking to move from lane 2 to 1
        
        if lanereg(1,1) ~= size(car,1) + 1 % if lane 1 contains cars
            
            R = round(mean(car(lanereg(1,1):lanereg(2,1),3))/2);
            
            rang = car(dex,2)-R:1:car(dex,2)+R;
            rang = rang + len.*double(rang <= 0);
            
            move = zeros(2,length(rang));
            move(1,:) = ismember(rang,car(lanereg(1,1):lanereg(2,1),2));
            
            move = double(~ismember(true,move));
            
        else
            
            move = 1;
            
        end
        
        car(dex,1) = car(dex,1) - move;
        
        car(dex,6) = 75*move;
        
%% attempt to move left
        
    elseif car(dex,1) ~= size(lanereg,2) && car(dex,6) == 0
        
        if lanereg(1,lane+1) ~= size(car,1) + 1
            
            R = round(mean(car(lanereg(1,lane+1):lanereg(2,lane+1),3))/2);
            
            rang = car(dex,2)-R:1:car(dex,2)+R;
            rang = rang + len.*double(rang <= 0);
            
            move = ismember(rang,car(lanereg(1,lane+1):lanereg(2,lane+1),2));
            move = double(~ismember(true,move));
            
        else
            
            move = 1;
            
        end
        
        car(dex,1) = car(dex,1) + move;
        
        car(dex,6) = 75*move;
        
    end
    
end

ret = car;

end