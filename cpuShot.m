function [cpu_shots, hitmiss_display, cpu_last_hit, hunting] = cpuShot(cpu_shots, user_ships, hitmiss_display, cpu_last_hit, diff, hunting, numTurns)
%cpuShot The cpu takes a "smart" shot

% The cpu will look over several things to take a shot

% 1. (Hard only) If the previous hit was on a non-sunken ship, check the
% spots around it for hits. If there are hits use the hits to guess with
% the orientation of the ship

% 2. If the previous hit was on a non-sunken ship, check around it for
% other hits or misses

% 3. If there is an unsunken ship, the cpu will keep "hunting" that ship
% until it is sunk



% Sprites for hitmiss_display
hit_sprite = 9;
miss_sprite = 10;

oldRow = cpu_last_hit(1);
oldColumn = cpu_last_hit(2);

cpuHit = false;
shotSelected = false;
row = 0;
column = 0;


% cpuHit ensures that the cpu has a previous valid hit
if(oldRow < 11 && oldColumn < 11)
    cpuHit = true;
end

% Hard difficulty ship tracing
if diff == 2
    
    if cpuHit && ~checkSunk(oldRow, oldColumn, cpu_shots, user_ships)
        
        % Checks the spot above the last hit for a hit and checks for a
        % boundary (Vertical ship tracking)
        if oldRow > 1 && oldRow < 10 && cpu_shots(oldRow - 1, oldColumn) == 1
            
            % Set vertical hunt (hunting = 1)
            hunting = 1;
            
            % Check 2 above the previous hit
            if oldRow > 2 && cpu_shots(oldRow - 2, oldColumn) == 0
                
                row = oldRow - 2;
                column = oldColumn;
                shotSelected = true;
                
            % Check one spot below the previous hit
            elseif cpu_shots(oldRow + 1, oldColumn) == 0
                
                row = oldRow + 1;
                column = oldColumn;
                shotSelected = true;
                
            end      
        end
        
        % Checks the spot below the last hit for a hit and checks for a
        % boundary (Vertical ship tracking)
        if oldRow > 1 && oldRow < 10 && cpu_shots(oldRow + 1, oldColumn) == 1 && ~shotSelected
            
            % Set vertical hunt
            hunting = 1;
            
            % Check 2 spots below the previous hit
            if oldRow < 9 && cpu_shots(oldRow + 2, oldColumn) == 0
                row = oldRow + 2;
                column = oldColumn;
                shotSelected = true;
                
            % Check the spot below the previous hit    
            elseif cpu_shots(oldRow - 1, oldColumn) == 0
                row = oldRow - 1;
                column = oldColumn;
                shotSelected = true;
                
            end         
        end
        
        % Checks the spot to the left of the last hit for a hit and checks
        % for a boundary (Horizontal ship tracking)
        if oldColumn > 1 && oldColumn < 10 && cpu_shots(oldRow, oldColumn - 1) == 1 && ~shotSelected
            
            % Set horizontal hunt
            hunting = 2;
            
            % Check 2 spots to the left of the prevous hit
            if oldColumn > 2 && cpu_shots(oldRow, oldColumn - 2) == 0
                row = oldRow;
                column = oldColumn - 2;
                shotSelected = true;
            
            % Check the spot to the right of the previous hit    
            elseif cpu_shots(oldRow, oldColumn + 1) == 0
                row = oldRow;
                column = oldColumn + 1;
                shotSelected = true;
                
            end
        end
        
        % Checks the spot to the right of the last hit for a hit and checks
        % for a boundary (Horizontal ship tracking)
        if oldColumn > 1 && oldColumn < 10 && cpu_shots(oldRow, oldColumn + 1) == 1 && ~shotSelected
            
            % Set horizontal hunt
            hunting = 2;
            
            %Check 2 spots to the right of the previous hit
            if oldColumn < 9 && cpu_shots(oldRow, oldColumn + 2) == 0
                row = oldRow;
                column = oldColumn + 2;
                shotSelected = true;
                
            % Check the spot to the left of the previous hit    
            elseif cpu_shots(oldRow, oldColumn - 1) == 0
                row = oldRow;
                column = oldColumn - 1;
                shotSelected = true;
            end
        end
                
    end
    
end

% Vertical hunt
if ~shotSelected && hunting == 1 && diff == 2
    row = oldRow;
    column = oldColumn;
    up = true;
    
    while ~shotSelected && hunting == 1
        
        if up && row > 1
            row = row - 1;
        elseif ~up && row < 10
            row = row + 1;
        end
        
        if cpu_shots(row, column) == 2 && ~up
            hunting = 0;
        elseif cpu_shots(row, column) == 2
            up = false;
        elseif cpu_shots(row, column) == 0
            shotSelected = true;
        end
    end

% Horizontal hunt    
elseif ~shotSelected && hunting == 2 && diff == 2
    row = oldRow;
    column = oldColumn;
    left = true;
    
    while ~shotSelected && hunting == 2
        
        if left && column > 1
            column = column - 1;
        elseif ~left && column < 10
            column = column + 1;
        end
        
        if cpu_shots(row, column) == 2 && ~left
            hunting = 0;
        elseif cpu_shots(row, column) == 2
            left = false;
        elseif cpu_shots(row, column) == 0
            shotSelected = true;
        end
    end
    
    
end
    
    

% Easy difficulty shot
if ~shotSelected
    
    % If there is a last hit and the last hit did not sink a ship, the spots around it are good choices
    if cpuHit && ~checkSunk(oldRow, oldColumn, cpu_shots, user_ships)
        
        % Check to see if any of the spots around the last hit are a good shot (not already tried and
        % on the board)
        if oldRow > 1 && cpu_shots(oldRow - 1, oldColumn) == 0
            row = oldRow - 1;
            column = oldColumn;
        elseif oldRow < 10 && cpu_shots(oldRow + 1, oldColumn) == 0
            row = oldRow + 1;
            column = oldColumn;
        elseif oldColumn > 1 && cpu_shots(oldRow, oldColumn - 1) == 0
            row = oldRow;
            column = oldColumn - 1;
        elseif oldColumn < 10 && cpu_shots(oldRow, oldColumn + 1) == 0
            row = oldRow;
            column = oldColumn + 1;
        end
    
        % Check to see if a shot was selected
        if row > 0 && column > 0
            shotSelected = true;
        end
    
    end
end

% Variable to decrease limitations on random location if a valid spot can't
% be found
numTries = 0;

% If a shot has not been selected, pick a "smart" random shot
while(~shotSelected)
    
    row = randi(10);
    column = randi(10);
    
         
    % If the random shot is in a valid location (no shots around it), exit the loop with shot
    % selected
    if cpu_shots(row, column) == 0
        % Check middle grid random shots
        if row > 1 && row < 10 && column > 1 && column < 10
            % If under 45 turns, requires spots around the shot to be empty
            if cpu_shots(row - 1, column) == 0 && cpu_shots(row + 1, column) == 0 && cpu_shots(row, column - 1) == 0 && cpu_shots(row, column + 1) == 0
                shotSelected = true;
            elseif (numTurns > 45 || numTries > 500) && (cpu_shots(row - 1, column) == 0 || cpu_shots(row + 1, column) == 0 || cpu_shots(row, column - 1) == 0 || cpu_shots(row, column + 1) == 0)
                shotSelected = true;
            end
        % Check a top row random shot
        elseif row == 1 && column > 1 && column < 10
            % If under 45 turns, requires spots around the shot to be empty
            if cpu_shots(row, column + 1) == 0 && cpu_shots(row, column - 1) == 0 && cpu_shots(row + 1, column)
                shotSelected = true;
            elseif (numTurns > 45 || numTries > 500) && (cpu_shots(row, column + 1) == 0 || cpu_shots(row, column - 1) == 0 || cpu_shots(row + 1, column))
                shotSelected = true;
            end
        % Check a bottom row random shot
        elseif row == 10 && column > 1 && column < 10
            % If under 45 turns, requires spots around the shot to be empty
            if cpu_shots(row, column + 1) == 0 && cpu_shots(row, column - 1) == 0 && cpu_shots(row - 1, column) == 0
                shotSelected = true;
            elseif (numTurns > 45 || numTries > 500) && (cpu_shots(row, column + 1) == 0 || cpu_shots(row, column - 1) == 0 || cpu_shots(row - 1, column) == 0)
                shotSelected = true;
            end
        % Check a left column random shot
        elseif column == 1 && row > 1 && row < 10
            % If under 45 turns, requires spots around the shot to be empty
            if cpu_shots(row + 1, column) == 0 && cpu_shots(row - 1, column) == 0 && cpu_shots(row, column + 1) == 0
                shotSelected = true;
            elseif (numTurns > 45 || numTries > 500) && (cpu_shots(row + 1, column) == 0 || cpu_shots(row - 1, column) == 0 || cpu_shots(row, column + 1) == 0)
                shotSelected = true;
            end
        % Check a right column random shot
        elseif column == 10 && row > 1 && row < 10
            % If under 45 turns, requires spots around the shot to be empty
            if cpu_shots(row + 1, column) == 0 && cpu_shots(row - 1, column) == 0 && cpu_shots(row, column - 1) == 0
                shotSelected = true;
            elseif (numTurns > 45 || numTries > 500) && (cpu_shots(row + 1, column) == 0 || cpu_shots(row - 1, column) == 0 || cpu_shots(row, column - 1) == 0)
                shotSelected = true;
            end
        else
            shotSelected = true;
        end
    end
    
    % Stops the cpu from randomly selecting corners on hard
    if ((row == 10 || row == 1) && (column == 10 || column == 1)) && diff == 2
        shotSelected = false;
    end
    
    numTries = numTries + 1;
end

% Now check the shot for hit or miss and add the result to the
% hitmiss_display
if(checkHit(row, column, user_ships))
    
    % Set cpu_shots at row, column to hit
    cpu_shots(row, column) = 1;
    
    % Update cpu_last_shot
    cpu_last_hit = [row column]; 
    
    % Reset to hunting = 0 (not hunting)
    if checkSunk(row, column, cpu_shots, user_ships)
        hunting = 0;
    end
    
    % Display hit sprite for hit
    hitmiss_display(row, column) = hit_sprite;
    
else
    
    % Set cpu_shots at row, column to miss
    cpu_shots(row, column) = 2;
    
    % Display miss sprite for a miss
    hitmiss_display(row, column) = miss_sprite;
    
end
    
end



