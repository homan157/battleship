% Function to allow user to select ship location

function [ user_ships, board_display ] = userSetup(my_scene, board_display)
    
    
%Set up variables to name the various sprites
left_ship_sprite = 3;
horiz_ship_sprite = 4;
right_ship_sprite = 5;
top_ship_sprite = 6;
vert_ship_sprite = 7;
bot_ship_sprite = 8;

% the "board" of ships is initially empty: 10 by 10 of zeros
user_ships = zeros(10,10);

% length of the ships, ship 1 is the carrier and has length 5, 
% ship 2 is the battleship, ship 3 is the submarine, ship 4 is the cruiser,
% and ship 5 is the PT boat
ship_length = [5,4,3,3,2];

% loop over each ship
for ship_id = 1:5
    
    % Variable to tell loop when placement is valid
    ship_placed = false;
    
    % Loops until ship has valid placement location
    while ~ship_placed
        
        % Get mouse input
        [row, column, button] = getMouseInput(my_scene);
        
        % Set vertical and horizontal placements to false
        vertical = false;
        horizontal = false;
        
        
        % If left click -> vertical = true
        % If right click -> horizontal = true
        if button == 3
            vertical = true;
        elseif button == 1
            horizontal = true;
        end
        
        % Use orientation to check for valid placement
        if horizontal
            
            % Calculates the end column of the ship
            shipEnd = column + ship_length(ship_id) - 1;
            
            if shipEnd <= 10
            
                % Checks for any current ships in selected placement
                if sum(user_ships(row,column:shipEnd)) ==  0
                
                
                    % Places ship in selected location
                    user_ships(row,column:shipEnd) = ship_id;
                
                    % Display ship locations
                    board_display(row,column:shipEnd) = horiz_ship_sprite;
                    board_display(row, column) = left_ship_sprite;
                    board_display(row, shipEnd) = right_ship_sprite;
                
                    % Tells loop that ship has been placed
                    ship_placed = true;
                end
                
            end
               
        elseif vertical
            
            % Calculates the end row of the ship
            shipEnd = row + ship_length(ship_id) - 1;
            
            if shipEnd <= 10
                
                % Checks for any current ships in selected placement
                if sum(user_ships(row:shipEnd,column)) == 0
                
                    % Places ship in selected location
                    user_ships(row:shipEnd,column) = ship_id;
                
                    % Display ship locations
                    board_display(row:shipEnd,column) = vert_ship_sprite;
                    board_display(row, column) = top_ship_sprite;
                    board_display(shipEnd, column) = bot_ship_sprite;
                
                    % Tells loop that ship has been placed
                    ship_placed = true;
                end
                
            end
       
        end
        
        if ~ship_placed
            errordlg('Can''t place ship there! Try again', 'Error')
        end
        
    end
    
    drawScene(my_scene, board_display)

end


        