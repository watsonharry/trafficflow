function ret = carGenAdv(len,lanes,N,V,sigma)
%% CARGEN Randomly place stationary car automata along an array of cells.
%
%   A = carGen(I,N,V) creates a matrix of car data for N cars along a road
%   of length I, with normally distributed max speeds around V, standard
%   deviation sigma.
%

ret = zeros(N,7);
occ = zeros(lanes,len); % matrix to keep track of which sites are occupied

% car IDs (to keep track of individual cars)
ret(:,7) = (1:1:N).';

% car max speeds (normal distribution around the speed limit)
ret(:,4) = round(normrnd(V,sigma,1,N));

% random cooldown values in ticks for cars moving left across lanes
ret(:,6) = round(rand(1,N).*25).';

% car placement
for n = 1:1:N % for every car
    
    h = round(rand*(lanes-1)+1); % pick a random lane
    m = round(rand*(len-1))+1; % pick a random site from 1 to I
    
    while occ(h,m) == 1 % if occupied, pick again
        h = round(rand*(lanes-1)+1);
        m = round(rand*(len-1))+1;
    end
    
    ret(n,1) = h; % encode lane to car
    ret(n,2) = m; % encode site number to car
    occ(h,m) = 1; % encode site as occupied
    
end

ret = sortrows(ret); % sort cars by lanes, then position

end