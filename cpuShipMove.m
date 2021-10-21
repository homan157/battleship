function [cpu_ships] = cpuShipMove(row, column, cpu_ships, user_shots)
%cpuShipMove The cpu will move the PT boat if it is hit to an open spot

copyRow = row;
copyColumn = column;

validMove = false;

triedMoves = 0;

if cpu_ships(row, column) == 5
    
    while validMove == false && triedMoves < 1000
        
        row = 0;
        column = 0;
        
        while row > 9 || row < 2 || column > 9 || column < 2
            row = randi(10);
            column = randi(10);
        end
        
    
        if user_shots(row, column) == 0 && cpu_ships(row, column) == 0
            if user_shots(row + 1, column) == 0 && cpu_ships(row + 1, column) == 0
                cpu_ships(row, column) = 5;
                cpu_ships(row + 1, column) = 5;
            elseif user_shots(row, column + 1) == 0 && cpu_ships(row, column + 1) == 0
                cpu_ships(row, column) = 5;
                cpu_ships(row, column + 1) = 5;
            elseif user_shots(row - 1, column) == 0 && cpu_ships(row - 1, column) == 0
                cpu_ships(row, column) = 5;
                cpu_ships(row - 1, column) = 5;
            elseif user_shots(row, column - 1) == 0 && cpu_ships(row, column - 1) == 0
                cpu_ships(row, column) = 5;
                cpu_ships(row - 1, column) = 5;
            end
            
            if cpu_ships(row, column) == 5
                validMove = true;
            end
        end
        
    end
    
    if validMove
        cpu_ships(copyRow, copyColumn) = 0;
        
        if copyRow < 10 && cpu_ships(copyRow + 1, copyColumn) == 5
            cpu_ships(copyRow + 1, copyColumn) = 0;
        elseif copyRow > 1 && cpu_ships(copyRow - 1, copyColumn) == 5
            cpu_ships(copyRow - 1, copyColumn) = 0;
        elseif copyColumn < 10 && cpu_ships(copyRow, copyColumn + 1) == 5
            cpu_ships(copyRow, copyColumn + 1) = 0;
        elseif copyColumn > 1 && cpu_ships(copyRow, copyColumn - 1) == 5
            cpu_ships(copyRow, copyColumn - 1) = 0;
        end
    end

end

