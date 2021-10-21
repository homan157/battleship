function [cpu_shots, hitmiss_display] = cpuCheat(cpu_shots, user_ships, hitmiss_display)
%cpuCheat Function that will obliterate the competition

% Sprites for hitmiss_display
hit_sprite = 9;
miss_sprite = 10;

% 25 percent chance to miss
keepHope = randi(4);

if keepHope == 1
    row = randi(10);
    column = randi(10);
    
else
    for i = 1:10
        for x = 1:10
            if user_ships(i,x) > 0 && cpu_shots(i,x) == 0
                row = i;
                column = x;
            end
        end
    end
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

