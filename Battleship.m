clc
clear

% Driver Program


% Select Difficulty
diff = listdlg('PromptString','Select a difficulty','SelectionMode','single','ListString', {'Easy', 'Hard'});


% Initialize scene
my_scene = simpleGameEngine('Battleship.png',84,84);

%Set up variables to name the various sprites
blank_sprite = 1;
water_sprite = 2;
left_ship_sprite = 3;
horiz_ship_sprite = 4;
right_ship_sprite = 5;
top_ship_sprite = 6;
vert_ship_sprite = 7;
bot_ship_sprite = 8;
hit_sprite = 9;
miss_sprite = 10;

% Display empty board
board_display = water_sprite * ones(10,21);
board_display(:,11) = blank_sprite;
drawScene(my_scene,board_display)

% Set up hits and misses layer
hitmiss_display = blank_sprite * ones(10,21);

% Create cpu and user ship boards
cpu_ships = Setup();
[user_ships, board_display] = userSetup(my_scene, board_display);

% "flip a coin" to see who goes first
coinFlip = randi(2);
if coinFlip == 1
    userTurn = true;
else
    userTurn = false;
end

% Initialize variables
user_shots = zeros(10, 10);
cpu_shots = zeros(10, 10);
cpu_last_hit = [11 11];
hunting = 0;
numTurns = 0;

% For use in implementation of "hit and sunk" LATER
user_sunk = 0;
cpu_sunk = 0;


% Loop until winner is declared
winner = false;
while(~winner)
    
    % Display Cpu ships for testing KEEP OFF
    %for i = 1:10
    %    for x = 1:10
    %        if cpu_ships(i, x) > 0
    %            board_display(i, x + 11) = 4;
    %        else
    %            board_display(i, x + 11) = 2;
    %        end
    %    end
    %end
    
    % User Turn code
    if userTurn
        
        % User takes a shot (display shot)
        [user_shots, hitmiss_display] = userShot(user_shots, cpu_ships, my_scene, hitmiss_display);
        
        % User CHEAT SHOT (impossible to win)
        %[user_shots, hitmiss_display, cpu_ships] = userCheatShot(user_shots, cpu_ships, my_scene, hitmiss_display);
        
        drawScene(my_scene, board_display, hitmiss_display)
        
        % Check for user win
        winner = checkWinner(user_shots);
        
        % If user did not win, switch to cpu turn
        if ~winner
            userTurn = false;
        end
                
    % Cpu turn code    
    else
        
        % Cpu takes a smart shot (display shot)
        [cpu_shots, hitmiss_display, cpu_last_hit, hunting] = cpuShot(cpu_shots, user_ships, hitmiss_display, cpu_last_hit, diff, hunting, numTurns);
        
        % Cpu cheat LEAVE THIS OFF
        %[cpu_shots, hitmiss_display] = cpuCheat(cpu_shots, user_ships, hitmiss_display);
        
        drawScene(my_scene, board_display, hitmiss_display);
        
        % Check for cpu win
        winner = checkWinner(cpu_shots);
        
        % If cpu did not win, switch to user turn
        if ~winner
            userTurn = true;
            numTurns = numTurns + 1;
        % If the cpu won display cpu ships (MAKE THIS BETTER)
        else
            for i = 1:10
                for x = 1:10
                    if cpu_ships(i, x) > 0
                        board_display(i, x + 11) = 4;
                    else
                        board_display(i, x + 11) = 2;
                    end
                end
            end
            drawScene(my_scene, board_display, hitmiss_display);
        end
        
    end
    

end

if userTurn
    
    % Print player wins
    msgbox('Congratulations! You Win!', 'Winner');
    
else
    
    % Print player loses
    msgbox({'You Lose!';'Better luck next time!'}, 'Loser');
    
end
