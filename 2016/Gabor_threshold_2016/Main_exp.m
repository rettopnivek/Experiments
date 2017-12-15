%-----------------------------------%
% Gabor priming with external noise %
% Kevin Potter                      %
% Updated 06/22/2016                %
%-----------------------------------%

%{
Purpose:
Matlab and Psychtoolbox code for running a priming task using overlaid
Gabor patches. The goal of the task is to determine 75% threshold
performance across different noise contrast levels.

Requirements:
Matlab R2013a or Matlab R2015a
Psychtoolbox

Outputs:
A .csv file with the stimuli and response information
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
%}

% Add path for additional functions
orig_dir = cd('Internal_functions');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Set debugging options
debug = 1;

if debug == 1
    % Skip Psychtoolbox synch tests
    Screen('Preference', 'SkipSyncTests', 1);
end

% Record when the experiment begins
startTime = clock;

% Determine output filenames and session number
Subject_ID_input

% Read in the RNG seeds
fileID = fopen('RNG_seeds.txt','r');
RNG_seeds = fscanf(fileID,'%d' );
fclose(fileID);
rng( RNG_seeds(SubjNum) ); % Set seed based on current subject
% rng shuffle; % Random seed for rng

% Run script to initialize stimuli/responses
Stimulus_initialization

% Run script to create conditions
reduced = 0;
Condition_Creation

% Run adaptive trials
if SessionNum == 1 || SessionNum == 2
    Adaptive_trials
end

% Record end of experiment
endTime = clock;

%{
% 1) RT, 2) Choice, 3) Accuracy 4) Target,
% 5) Prime 6) Prime duration 7) Foil contrast 8) Target contrast
% 9) Proportion 10) Rotation angle 11) Block

% Save results to file
orig_dir = cd('Subjects');
fid = fopen(csvOutputFile{1}, 'wt'); % Open for writing
fprintf(fid, 'Subject,RT,Choice,Accuracy,Target,Prime,PrimeDuration,FoilContrast,TargetContrast,Rho,Angle,Block\n');
for i=1:size(allResults,1)
   fprintf(fid, '%d,', SubjNum );
   fprintf(fid, '%d,', allResults(i,1:(size(allResults,2)-1)));
   fprintf(fid, '%d', allResults(i,size(allResults,2)));
   fprintf(fid, '\n');
end
fclose(fid);
%}

% Indicate that the experiment is finished
instruct = [ 'Congratulations! You''ve finished the experiment.\n' ...
    'You will now be paid for your participation. \n' ...
    'If you have any questions, contact information \n' ...
    'is provided on the debriefing form. Thanks again for \n' ...
    'your efforts!' ];
[nx,ny,bbox] = displayInstruct( window, instruct, center, lnSpace, InstructionTime, pakSpace );

% Terminate experiment
KbStrokeWait;

% Clear the screen
clear Screen;
sca;