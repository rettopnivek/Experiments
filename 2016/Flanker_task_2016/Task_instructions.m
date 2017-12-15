%---------------------------%
% Experimental instructions %
%---------------------------%

% Define the instructions
instruct = num2str( ones(2,1) ); % Create a cell string array
instruct = cellstr(instruct);
% Fill the array with the individual lines of instructions
instruct{1} = 'In this study, you will complete what is known as the';
instruct{2} = '"Eriksen flanker task". On each trial, you will see ';
instruct{3} = 'one of two symbols appear in the center of the screen.';
instruct{4} = 'This central symbol will be flanked on either side by ';
instruct{5} = '2 repetitions of a) the same symbol or b) the other symbol.';
instruct{6} = 'You must indicate what the central symbol is. ';
instruct{7} = ' ';
instruct{8} = 'Press any key to continue';
lenIns = length(instruct);

% Display the instructions
displayInstruct % Call separate Matlab script

% Display an example of the stimulus presentation
clrExample = [ 0 0 0 ];
string = 'This is an example of what you will see:';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*3 );
DrawFormattedText(window, string, 'center',center(2)-strPos, clrExample );

Flanker_draw( stim1, stim1xPos, yPos(1), clrExample, window )
Target_draw( stim2, stim2xPos, yPos(2), clrExample, window )

Screen('Flip', window);
WaitSecs(3) % Delay for reading time

clrExample = [ 0 0 0 ];
string = 'This is an example of what you will see:';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*3 );
DrawFormattedText(window, string, 'center',center(2)-strPos, clrExample );

clrExample = [ 1 0 0 ];
string = 'Ignore these';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*.5 );
DrawFormattedText(window, string, 'center',center(2)+strPos, clrExample );

Flanker_draw( stim1, stim1xPos, yPos(1), clrExample, window )

clrExample = [ 0 0 1 ];
string = 'Pick this';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*1.5 );
DrawFormattedText(window, string, 'center',center(2)-strPos, clrExample );

Target_draw( stim2, stim2xPos, yPos(2), clrExample, window )

Screen('Flip', window);
WaitSecs(.5) % Delay for reading time

clrExample = [ 0 0 0 ];
string = 'This is an example of what you will see:';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*3 );
DrawFormattedText(window, string, 'center',center(2)-strPos, clrExample );

clrExample = [ 1 0 0 ];
string = 'Ignore these';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*.5 );
DrawFormattedText(window, string, 'center',center(2)+strPos, clrExample );

Flanker_draw( stim1, stim1xPos, yPos(1), clrExample, window )

clrExample = [ 0 0 1 ];
string = 'Pick this';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*1.5 );
DrawFormattedText(window, string, 'center',center(2)-strPos, clrExample );

Target_draw( stim2, stim2xPos, yPos(2), clrExample, window )

WaitSecs(.5) % Delay for reading time

string = 'Press any key to continue';
[dim] = Screen(window, 'TextBounds', string);
strPos = dim(4)/2 + round( dim(4)*3 );
DrawFormattedText(window, string, 'center',center(2)+strPos, [ 0 0 0 ] );

Screen('Flip', window);

% Press any key to continue
KbStrokeWait;

% Define the instructions
instruct = num2str( ones(2,1) ); % Create a cell string array
instruct = cellstr(instruct);
% Fill the array with the individual lines of instructions
instruct{1} = [ 'Press "' keys(1) '" to indicate the central symbol is ' stim1 '.'];
instruct{2} = [ 'Press "' keys(2) '" to indicate the central symbol is ' stim2 '.'];
instruct{3} = '';
instruct{4} = 'Try to be as fast and accurate as possible! After your choice, ';
instruct{5} = 'you will be told whether you were correct, made an error, ';
instruct{6} = 'or were too slow.';
instruct{7} = ' ';
instruct{8} = 'Press any key to continue';
lenIns = length(instruct);

% Display the instructions
displayInstruct % Call separate Matlab script

% Define the instructions
instruct = num2str( ones(2,1) ); % Create a cell string array
instruct = cellstr(instruct);
% Fill the array with the individual lines of instructions
instruct{1} = 'You will earn points based on your performance. Try to get ';
instruct{2} = 'as many points as possible. You are doing well if you have ';
instruct{3} = 'a positive score.';
instruct{4} = '';
if ptsCorrect==abs(1)
    ptsText = ' point.';
else
    ptsText = ' points.';
end
instruct{5} = ['If you are correct you will earn ' num2str(ptsCorrect) ptsText ];
if ptsError==abs(1)
    ptsText = ' point.';
else
    ptsText = ' points.';
end
instruct{6} = ['If you make an error you will earn ' num2str(ptsError) ptsText ];
if ptsSlow==abs(1)
    ptsText = ' point.';
else
    ptsText = ' points.';
end
instruct{7} = ['If you are too slow you will earn ' num2str(ptsSlow) ptsText ];
instruct{8} = '';
instruct{9} = 'Press any key to continue';
lenIns = length(instruct);

% Display the instructions
displayInstruct % Call separate Matlab script

% Define the instructions
instruct = num2str( ones(2,1) ); % Create a cell string array
instruct = cellstr(instruct);
% Fill the array with the individual lines of instructions
instruct{1} = [ 'You will complete a practice block of ' num2str(sum(nTrialsByBlocks(1,:))) ' trials. You will ' ];
instruct{2} = [ 'then complete ' num2str(nBlocks-1) ' blocks of ' num2str(sum(nTrialsByBlocks(2,:))) ' trials each. Again, try to be ' ];
instruct{3} = 'as quick and accurate as possible! The task can be dull, ';
instruct{4} = 'so we appreciate your effort!';
instruct{5} = ' ';
instruct{6} = 'Press any key to continue';
lenIns = length(instruct);

% Display the instructions
displayInstruct % Call separate Matlab script