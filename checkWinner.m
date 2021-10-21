function [winner] = checkWinner(shots)
%checkWinner Checks if there is a winner

winner = false;
hits = 0;

% Iterate through the shot board and check for all hits, tally the hits
% For loop for row
for i=1:10
    % For loop for column
    for x=1:10
        % If shots(i,x) == 1 then that space is a hit
        if shots(i,x) == 1
            hits = hits + 1;
        end
    end
end

% If a shot board has 17 hits, then they have hit all ships
if hits == 17
    winner = true;
end

end