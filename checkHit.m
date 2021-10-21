function [isHit] = checkHit(row, column, ship_board)
%checkHit Checks coordinates on a board for a ship

% Check for ship located at (row, column)
if(ship_board(row, column) > 0)
    
    % Shows that ship is located at row, column
    isHit = true;
    
else
    
    % Shows that no ship is located at row, column
    isHit = false;
    
end

end