function [sunk] = checkSunk(row, column, shots, ships)
%checkSunk checks to see if the ship that was hit has been sunk


% Variable for sunken ship
sunk = false;

% Variables for ship_id and number of hits
ship_id = ships(row, column);
numHits = 0;

shipLength = [5 4 3 3 2];

for i = 1:10
    for x = 1:10
        if ships(i, x) ==  ship_id && shots(i, x) == 1
            % Add to the number of hits
            numHits = numHits + 1;
            
        end
    end
end

% If number of hits == ship_id length then the ship is sunken
if numHits == shipLength(ship_id)
    sunk = true;
end
            
end

