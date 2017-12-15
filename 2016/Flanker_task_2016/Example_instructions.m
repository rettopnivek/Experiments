% Initialize Psychtoolbox
PTB_initial

rng shuffle; % Random seed for rng

%%% Initialize variables for stimulus presentation %%%
% Lookup - 02

% Setup the text type for the stimuli
Screen('TextFont', window, 'Ariel');
stimFontSize = 18;
clr = [ 0 0 0]; % Color of the stimuli

% Create the symbols to use in the flanker task
stim1 = 'X'; % < is coded as 1
stim2 = 'K'; % > is coded as 2
% Define the spacing between the symbols (in pixels)
spacing = 5;

% Determine the boundaries (in pixels) within which the two stimuli will 
% be drawn. The first vector (i.e. bounds1 or bounds 3) has four values, 
% the last two denote the x and y values.
[bounds1, bounds2] = Screen(window, 'TextBounds', stim1);
[bounds3, bounds4] = Screen(window, 'TextBounds', stim2);

% Determine positions for the flanker, based on ordering given below:
% 1 = Flanker, 2 = Flanker, 3 = Target, 4 = Flanker, 5 = Flanker
stim1xPos = [ center(1) - ( (5*round(bounds1(3)/2) + 2*spacing ) ), ...
              center(1) - ( (3*round(bounds1(3)/2) + 1*spacing ) ), ...
              center(1) - ( (1*round(bounds1(3)/2) + 0*spacing ) ), ...
              center(1) + ( (1*round(bounds1(3)/2) + 1*spacing ) ), ...
              center(1) + ( (3*round(bounds1(3)/2) + 2*spacing ) ) ];
stim2xPos = [ center(1) - ( (5*round(bounds3(3)/2) + 2*spacing ) ), ...
              center(1) - ( (3*round(bounds3(3)/2) + 1*spacing ) ), ...
              center(1) - ( (1*round(bounds3(3)/2) + 0*spacing ) ), ...
              center(1) + ( (1*round(bounds3(3)/2) + 1*spacing ) ), ...
              center(1) + ( (3*round(bounds3(3)/2) + 2*spacing ) ) ];
yPos = [ center(2)-round(bounds1(4)/2), center(2)-round(bounds3(4)/2) ];

% Set key assignment
CB = 1; % Counter-balancing condition
if CB==1
    % stimulus 1 is left, stimulus 2 is right
    keys = 'jk';
    keyOptions = getKeyAssignments(keys,1,300);
end
if CB==2
    % stimulus 2 is left, stimulus 1 is right
    keys = 'kj';
    keyOptions = getKeyAssignments(keys,1,300);
end

% Point allocation
ptsError = -4;
ptsCorrect = 1;
ptsSlow = -4;

% Define the number of blocks
nBlocks = 2 + 1;

% Let...
% CH = congruent trials, H is target
% CS = congruent trials, S is target
% IH = incongruent trials, H is target
% IS = incongruent trials, S is target

% Define number of trials per condition and block
% For columns, order is CH, CS, IH, IS
% For rows, 1st is practice, second is main experiment
nTrialsByBlocks = [ 15 15 15 15; ...
                    20 20 20 20 ];

% Define the instructions
Task_instructions

% Clear the screen
clear Screen;
% clear all;
sca;