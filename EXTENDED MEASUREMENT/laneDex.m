function ret = laneDex(lanereg,car)
ret = lanereg;
for lane = 1:1:size(ret,2)
    if ismember(lane,car(:,1)) == 1
    ret(1,lane) = find(car(:,1) == lane,1,'first');
    ret(2,lane) = find(car(:,1) == lane,1,'last');
    else % if no cars in lane, use dummy value outside of data range
    ret(1,lane) = size(car,1)+1;
    ret(2,lane) = size(car,1)+1;
    end
end

end