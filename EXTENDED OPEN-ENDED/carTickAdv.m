function ret = carTickAdv(car,len,lanereg,p,N,lanes)

% acceleration
car(:,3) = car(:,3) + double(car(:,3) < car(:,4)); % v = v+1 if v < V

% overtaking
if lanes ~= 1 % only worry about overtaking if multiple lanes
    for id = 1:1:N % for each car (identified via ID)
        dex = find(car(:,7) == id);
        if car(dex,6) <= 50
            car = carOver(car,len,lanereg,dex);
        end
        % ^ only bother if car isn't on lane-changing cooldown
    end
    car = sortrows(car); % re-sort car matrix
    lanereg = laneDex(lanereg,car); % re-encode lane data indexing
end

% slowing down due to other cars
for lane = 1:1:lanes % for each lane
    dex = lanereg(1,lane); % begin with the fist data entry for that lane
    if dex ~= lanereg(2,lane) % the lane is occupied, by more than one car
    % NOTE: cars in lanes alone will not check if they need to slow
        while dex ~= lanereg(2,lane) % until the final entry is reached
            wrap = double(car(dex+1,2) < car(dex,2)); % next car wrapped?
            coll = car(dex+1,2) + len*wrap - car(dex,2) - car(dex,3) <=0;
            if coll == 1 % if collision would occur
                car(dex,3) = car(dex+1,2) + len*wrap - car(dex,2) - 1;
                % ^ aim for site behind next car
            end
            dex = dex + 1;
        end
        % repeat slowing process for final car in lane
        wrap = double(car(lanereg(1,lane),2) < car(dex,2));
        coll = car(lanereg(1,lane),2) + len*wrap - car(dex,2)...
            - car(dex,3) <= 0;
        if coll == 1
            car(dex,3) = car(lanereg(1,lane),2) + len*wrap - car(dex,2) - 1;
        end
    end
end

% random slowing
for dex = 1:1:N
    r = rand;
    if r <= p && car(dex,3) > 0 % with prob. 0.3 and if car is moving
        car(dex,3) = car(dex,3)-1; % reduce speed by 1
    end
end

% advance cars
car(:,2) = car(:,2) + car(:,3);

% check for wrapping, take flow measurements, tick cooldowns
for dex = 1:1:N % check for wrapping
    
    if car(dex,2) > len % if car is out of bounds
        car(dex,2) = car(dex,2) - len; % wrap it to the start
        car(dex,5) = car(dex,5) + 1; % add a flow counter
    end
    
    if car(dex,6) ~= 0
        car(dex,6) = car(dex,6) - 1; % tick cooldowns
    end
    
end

ret = car; % update car data

end