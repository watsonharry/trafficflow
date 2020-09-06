function ret = carTickFlow(car,I,V,p)

N = length(car); % check how many cars there are and assign a variable

% acceleration
car(2,:) = car(2,:) + double(car(2,:) < V); % v = v+1 if v < V

% slowing down due to other cars
for n = 1:1:N-1 % -1 because final car must consider first car
    wrap = double(car(1,n+1) < car(1,n)); % check whether going to wrap
    coll = car(1,n+1) + I*wrap - car(1,n) - car(2,n) <= 0; % collision?
    if coll == 1
        car(2,n) = car(1,n+1) + I*wrap - car(1,n) - 1; % aim for site
    end                                                % behind next car
end

% repeat slowing process between last car and first car
wrap = double(car(1,1) < car(1,N)); % check whether going to wrap
coll = car(1,1) + I*wrap - car(1,N) - car(2,N) <= 0; % collision?
if coll == 1
    car(2,N) = car(1,1) + I*wrap - car(1,N) - 1;
end

% random slowing
for n = 1:1:N
    r = rand;
    if r <= p && car(2,n) > 0
        car(2,n) = car(2,n)-1;
    end
end

% advance cars
car(1,:) = car(1,:) + car(2,:);

% check for wrapping & take flow measurements
for n = 1:1:N % check for wrapping
    if car(1,n) > I % if car is out of bounds
        car(1,n) = car(1,n) - I; % wrap it to the start
        car(3,n) = car(3,n) + 1; % add a flow counter
    end
end

ret = car; % update car data

end