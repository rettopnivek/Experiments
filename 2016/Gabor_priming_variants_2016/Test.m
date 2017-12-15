%-------------%
% Draft trial %
%-------------%

% Add path for additional functions
orig_dir = cd('Internal_functions');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Add path for trial scripts
orig_dir = cd('Stimuli');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Add path for psychophysics functions
orig_dir = cd('Psychophysics');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Add path for task scripts
orig_dir = cd('Task_scripts');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

debug = 1;
% Set debug options
if debug == 1
    % Skip Psychtoolbox synch tests
    Screen('Preference', 'SkipSyncTests', 1);
end

Stimulus_initialization

string = 'Test run';
DrawFormattedText( window, string,'center','center', [], [], [], [], [], [], [] );

% Flip to the screen (i.e. display stimuli)
Screen('Flip', window);

WaitSecs = .5;

rot = 45;
primeMask = 1;
neitherPrime = 0;
nuisanceInputs = {
    window;
    imSize;
    choiceR;
    center;
    ovalSize1;
    ovalSize2;
    ovalRadius1;
    ovalRadius2;
    RadiusPrp;
    rot;
    nPoints;
    primeMask;
    neitherPrime;
    maskString };
getResponseMultipleStatic( keyOptions(1:2),[ 0 1 ], timeout, ifi, ...
    nuisanceInputs );

% Close all textures
Screen('Close');

% Clear the screen
clear Screen;
sca;
