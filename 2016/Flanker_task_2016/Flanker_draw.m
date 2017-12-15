function [  ] = Flanker_draw( stim, stimPos, yPos, clr, windowPtr )
% Flanker_draw: A function to draw flankers to the screen
%   stim    - The stimulus to draw (a single letter)
%   stimPos - A vector of the x-axis positions to draw the flankers
%   yPos    - The y-axis position to draw the flankers
%   clr     - A vector of three values defining the colors of the flankers
%             where [ 0 0 0 ] is black, and [ 1 1 1 ] is white.
    Screen('DrawText', windowPtr, stim, stimPos(1), yPos, clr);
    Screen('DrawText', windowPtr, stim, stimPos(2), yPos, clr);
    Screen('DrawText', windowPtr, stim, stimPos(4), yPos, clr);
    Screen('DrawText', windowPtr, stim, stimPos(5), yPos, clr);
end

