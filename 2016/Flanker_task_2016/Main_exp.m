%------------------------------------------------%
% Eriksen flanker task with adaptive RT deadline %
% Kevin Potter                                   %
% Updated 02/02/2016                             %
%------------------------------------------------%

%{
Purpose:
A Matlab script to run a version the Eriksen flanker task that has 
adaptive individual deadlines for RTs based on performance in a previous 
block, and has feedback after each trial.

Requirements:
Matlab R2013a
Psychtoolbox

Outputs:
A .csv file with the stimuli and response information
A .mat file with the starting and ending time, and the stimuli ordering
info
A text file with demographics information

Notes:
- To prematurely end the experiment, press shift + 2.
- Thanks is extended to Will Hopper and Angela Nelson Lowe for help with
  the code in Matlab
- Run the Test1a.m file first on certain machines to make sure Psychtoolbox
  is working.
- Use the key shortcut Win+P to change from dual to single monitor (Win is
  the key with the Windows logo).

Index:
Lookup - 01:  Pre-experiment setup
Lookup - 02:  Initialize variables for stimulus presentation
Lookup - 03:  Initialize variables for responses
Lookup - 04:  Initialize variables for stimulus timing
Lookup - 05:  Set up blocks
Lookup - 06:  Instructions
Lookup - 07:  Experimental trials
Lookup - 08:  End of experiment

%}

%%% Pre-experiment setup %%%
% Lookup - 01

% Record when the experiment begins
startTime = clock;

% Determine output filenames
Subject_ID_input

% Convert the ID number from a string to a number for later indexing
SubjNum = [];
for i = 9:11
    if ( isempty(str2num(csvOutputFile{1}(i)))==0 )
        if ( real( str2num(csvOutputFile{1}(i) ) ) >= 0 )
            SubjNum = [ SubjNum csvOutputFile{1}(i) ];
        end;
    end;
end;
SubjNum = str2num( SubjNum );

% Read in the RNG seeds
fileID = fopen('RNG_seeds.txt','r');
RNG_seeds = fscanf(fileID,'%d' );
fclose(fileID);
rng( RNG_seeds(SubjNum) ); % Set seed based on current subject
% rng shuffle; % Random seed for rng

% Determine demographics info based on NIH standards
Demographics
% Rename the demographics file
movefile('Demographics.txt',demographicsFile{1});
% Move the file to the subjects folder
movefile(demographicsFile{1},'Subjects');

% Initialize Psychtoolbox
PTB_initial

% Hide the mouse curser
HideCursor();

%%% Initialize variables for stimulus presentation %%%
% Lookup - 02

% Setup the text type for the stimuli
Screen('TextFont', window, 'Ariel');
stimFontSize = 18;
clr = [ 0 0 0]; % Color of the stimuli

% Create the symbols to use in the flanker task
stim1 = '<'; % Coded as 1
stim2 = '>'; % Coded as 2
% Define the spacing between the symbols (in pixels)
spacing = 5;

% Determine the boundaries (in pixels) within which the two stimuli will 
% be drawn. The first vector (i.e. bounds1 or bounds 3) has four values, 
% the last two denote the x and y values.
[bounds1] = Screen(window, 'TextBounds', stim1);
[bounds3] = Screen(window, 'TextBounds', stim2);

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

%%% Initialize variables for responses %%%
% Lookup - 03

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
ptsError = -1.5;
ptsCorrect = 1;
ptsSlow = -1.5;

%%% Initialize variables for stimulus timing %%%
% Lookup - 04

% Units are in ms
% Fixation point                - 100
% Interstimulus gap 1           - 300
% Flanker + Target presentation - 50

% Vector of desired times in ms for frames to approximate
FT = [ 100, 300, 50 ];

% Starting deadline             - 800
% Response interval             - Up to 3950
% Feedback                      - 1000
% Interstimulus gap             - 100

start_deadline = 800;
start_deadline = start_deadline/1000; % Convert to seconds
Response_interval = 3950;
Response_interval = Response_interval/1000; % Convert to seconds
Feedback_time = 400;
Feedback_time = Feedback_time/1000; % Convert to seconds
Interstimulus_gap = 100;
Interstimulus_gap = Interstimulus_gap/1000; % Convert to seconds

% Calculate the number of frames needed
tmp = ifi*1000;
frameVector = [ ms_to_frames(FT(1),tmp) ms_to_frames(FT(2),tmp) ...
                ms_to_frames(FT(3),tmp) ];
numFrames = sum(frameVector);
frame_index = cumsum(frameVector);

%%% Set up blocks %%%
% Lookup - 05

% Define the number of blocks
nBlocks = 12 + 1;

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

%%% Instructions %%%
% Lookup - 06

% Run matlab script to generate task instructions
Task_instructions

%%% Experimental trials %%%
% Lookup - 07

% Run matlab script to loop through blocks
Blocks

%%% End of the experiment %%%
% Lookup - 08

% Record end of experiment
endTime = clock;

% Save results to file
orig_dir = cd('Subjects');
% 1) Subject Number 2) RT, 3) Choice, 4) Correct, 5) Accuracy, 6) Slow, 
% 7) Congruent, 8) Block, 9) Points, 10 - 12) Stimulus timing
fid = fopen(csvOutputFile{1}, 'wt'); % Open for writing
fprintf(fid, 'Subject, RT, Choice, Correct, Accuracy, Slow, Congruent, Block, Points, FixTime, GapTime, StimTime\n');
for i=1:size(allResults,1)
   fprintf(fid, '%d,', SubjNum );
   fprintf(fid, '%d, ', allResults(i,1:(size(allResults,2)-1)));
   fprintf(fid, '%d', allResults(i,size(allResults,2)));
   fprintf(fid, '\n');
end
fclose(fid);

% Record Matlab output as well
save(matOutputFile{1},'allResults','startTime','endTime','SubjNum');

% Return to the original directory
cd(orig_dir);

% Indicate that the experiment is finished
instruct = num2str( ones(2,1) ); % Create a cell string array
instruct = cellstr(instruct);
instruct{1} = 'Congratulations, you have finished the study. Please ';
instruct{2} = 'let the experimenter know that you are done and pick up ';
instruct{3} = 'your debriefing form. We appreciate your participation!';
instruct{4} = ' ';
instruct{8} = ' ';
lenIns = length(instruct);

% Display the instructions
displayInstruct % Call separate Matlab script

% Clear the screen
clear Screen;
sca;

% Run script to add to experiment log
Experiment_log
