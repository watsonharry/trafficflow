function ret = carSpeed(spavg,car,lanereg,N)

for n = 1:1:size(lanereg,2) % for each lane
    
    if lanereg(1,n) ~= N+1 % if there are cars on the lane
    
    strt = lanereg(1,n);
    fnsh = lanereg(2,n);
    % ^ determine where its speed data begins and ends in main matrix
    
    av = mean(car(strt:fnsh,3));
    spavg(n) = av;
    % ^ calculate the average speed and assign it to corresponding array
    % element
    
    else
        
        spavg(n) = 0;
        
    end
    
end

ret = spavg; % output result

end