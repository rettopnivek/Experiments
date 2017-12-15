%--------------------------------------%
% Stimulus and response initialization %
%--------------------------------------%

rng shuffle; % Random seed for rng

% Initialize Psychtoolbox
PTB_initial

% Check if framerate is 60 Hz
if (ifi > .017)
    % Indicate that the monitor is set to the wrong refresh rate
    warning = 'Please press shift+2 and set monitor frame rate to at least 60 Hz';
    DrawFormattedText(window, warning,'center','center',[ 0 0 0 ] );
    % Flip to the screen (i.e. display stimuli)
    Screen('Flip', window);
    return
end

% Hide the mouse curser
HideCursor();

%%% Initialize variables for stimulus presentation %%%

% Set the font and text size
Screen('TextFont',window,'Monospace');
Screen('TextSize',window,20);

% Set the dimensions and color of the fixation dot
dotSizePix = 10;
dotColor = [0 0 0];

% Set the dimensions for the annulus
ovalRadius1 = 35;
ovalSize1 = [ center(1) - ovalRadius1, center(2) - ovalRadius1, ...
    center(1) + ovalRadius1, center(2) + ovalRadius1 ];

ovalRadius2 = ovalRadius1 + 15;
ovalSize2 = [ center(1) - ovalRadius2, center(2) - ovalRadius2, ...
    center(1) + ovalRadius2, center(2) + ovalRadius2 ];

% Set the dimensions for the ovals of the clock prime/mask
RadiusPrp = .6;
nPoints = 15; % Number of ovals to draw for mask

% Set image size for gabor patch\noise
imSize = 100;
% Set number of stripes in gabor patch ( 5 = ~3 visible stripes )
stripes = 5;
% Set size of gaussian window (Larger values lead to less of a gaussian
% mask; .2 is a typical value)
gaussWin = .2;
% Set angle of gratings
theta = [ 35 40 45 50 55 ];
% Set foil contrast (Between 0 and .5)
C_RMS_F = [ .041 .068 .112 .184 .303 ];
% Set size of gaussian window for noise
gaussWinNoise = .2;
% Set the interval before a time-out response is recorded (in seconds)
timeout = 4.995;
% Set distance from center for the 'Press any key' phrase
pakSpace = 250;
% Set line spacing for instructions
lnSpace = 1.5;

% Define the stimulus timing
totalTime = 1500; % In milliseconds
primeTimes = [ 50 400 ];
targetTime = 100;
postMaskTime = 100;
feedbackTime = .5; % In seconds
InstructionTime = 2;

if debug == 1
    totalTime = 100;
    primeTimes = [ 17 17 ];
    targetTime = 17;
    postMaskTime = 17;
    feedbackTime = .05; % In seconds
    InstructionTime = .01;
end

%%% Initialize variables for responses %%%

% Set keys for responses
keys = 'jk';
keyOptions = getKeyAssignments(keys,1,300);

% Empty vector to store results
allResults = [];
