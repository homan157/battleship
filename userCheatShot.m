function [user_shots, hitmiss_display, cpu_ships] = userCheatShot(user_shots, cpu_ships, my_scene, hitmiss_display)
% userShot Takes the cpu ship location and user shots, allows the user to take a shot and checks for hit or miss

% user_shots will define 0 for no shot, 1 for hit, and 2 for miss

[y, Fy] = audioread('Explosion.wav');
[x, Fx] = audioread('Water-Bloop.mp3');
[hit, Fh] = audioread('HitAndSunk.mp3');

% Sprites for hitmiss_display
hit_sprite = 9;
miss_sprite = 10;

validShot = false;

while ~validShot
    
    % Variable for location of shot on display
    Dispcolumn = 1;
    
    % Take mouse input and ensure it is on the cpu board
    while(Dispcolumn < 12)
        [row, Dispcolumn] = getMouseInput(my_scene);
    end
    
    column = Dispcolumn - 11;
    
    % Check if user has already taken a shot here
    if(user_shots(row, column) == 0)
        
        % Shot is valid
        validShot = true;
        
    end
    
end

%CPU MOVE SHIP CHEAT LEAVE THIS OFF
if(checkHit(row, column, cpu_ships))
    cpu_ships = cpuShipMove(row, column, cpu_ships, user_shots);
end

% Check for a hit at shot location
if(checkHit(row, column, cpu_ships))
        
    % Set user_shots at row, column to hit
    user_shots(row, column) = 1;
        
    % Display hit sprite for hit
    hitmiss_display(row, Dispcolumn) = hit_sprite;
    
    % Tell user if they have sunken a ship
    if checkSunk(row, column, user_shots, cpu_ships)
        % Play hit and sunk
        sound(hit, Fh);
    else
        % Play hit sound
        sound(y, Fy);
    end
        
else
        
    % Set user_shots at row, column to miss
    user_shots(row, column) = 2;
    
    % Play miss sound
    sound(x, Fx);
        
    % Display miss sprite for miss
    hitmiss_display(row, Dispcolumn) = miss_sprite;
        
end
    

end