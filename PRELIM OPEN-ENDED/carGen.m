function ret = carGen(I,N)
%% CARGEN Randomly place stationary car automata along an array of cells.
%
%   A = carGen(I,N) creates an array of N car positions along an
%   array of I cells.
%

ret = zeros(1,N);
occ = zeros(1,I); % an array to keep track of which sites are occupied

for n = 1:1:N % for every car
    
    m = ceil(rand*(I-1))+1; % pick a random site from 1 to I
    
    while occ(m) == 1
        m = round(rand*(I-1))+1; % if occupied, pick again
    end
    
    ret(n) = m; % encode site number to car
    occ(m) = 1; % encode site as occupied
    
end

ret = sort(ret); % sort the cars into order and return the pos. values

end