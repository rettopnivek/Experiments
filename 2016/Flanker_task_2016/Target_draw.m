function [  ] = Target_draw( stim, stimPos, yPos, clr, windowPtr )
% Flanker_draw: A function to draw flankers to the screen
%   stim    - The stimulus to draw (a single letter)
%   stimPos - The x-axis positions to draw the target
%   yPos    - The y-axis position to draw the target
%   clr     - A vector of three values defining the color of the target
%             where [ 0 0 0 ] is black, and [ 1 1 1 ] is white.
    Screen('DrawText', windowPtr, stim, stimPos(3), yPos, clr);
    
end