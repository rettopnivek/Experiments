%-------------------------------------------------%
% Onscreen script to create filenames for current %
% experiment                                      %
%-------------------------------------------------%

%{
Notes:
This script should be run before creating a windows pointer for
Psychtoolobox
%}

% Check if the Subject folder exists. If not, create it.
folderCheck = exist('Subjects','dir');
if (~folderCheck)
    mkdir('Subjects');
end;

% Change over to directory with output files
orig_dir = cd('Subjects');

% Set initial variables
IDconfirm = 0;
boxSize = [ 250, 100 ]; % Set the width and height of the dialog box
allFiles = dir;

while IDconfirm == 0
    
    confirmChoices = 0;
    
    boxSize = [ 300, 150 ]; % Set the width and height of the dialog box
    prompt = {...
        'Please enter subject ID number:' ...
        'Please enter study type (1 = priming, 2 = psychophysics)' ...
        'Please enter prime version (1 = dots, 2 = gabor)' ...
        'Please enter mode (0 = normal, 1 = debug)' ...
        'Please enter calibration type (1 = Adaptive, 2 = Staircase) ' ...
        };
    dlg_title = 'Options';
    num_lines = 1;
    promptResults = inputdlg(prompt,dlg_title,num_lines);
    
    % If they choose cancel, exit Matlab
    if isempty(promptResults)
        exit();
    end
    
    IDnum = promptResults{1};
    StudyType = str2num( promptResults{2} );
    PrimeVer = str2num( promptResults{3} );
    debug = str2num( promptResults{4} );
    CalType = str2num( promptResults{5} );
    
    % Create output file names
    csvOutputFile = strcat('Subject_',IDnum,'.csv');
    % stimOutputFile = strcat('Subject_',IDnum,'_Stim.csv');
    matOutputFile = strcat('Subject_',IDnum,'.mat');
    demographicsFile = strcat('Subject_',IDnum,'_demographics.txt');
    
    % Define the initial prompt
    stringPrompt = [ {sprintf('Are these the desired filenames?')} ...
        {sprintf( [ csvOutputFile ' and ' matOutputFile '.' ] )} ...
        {''} ];
    
    % Define the choices that can be selected
    Choices = [ {'Yes'} {'No'} ];
    
    % Create a list dialog box and determine the selection
    sel = listdlg('PromptString',stringPrompt,...
        'SelectionMode','single',... % So people can only pick one option
        'ListString',Choices,...
        'ListSize',boxSize,...
        'CancelString','Cancel');
    
    if isempty(sel)
        break
    elseif sel == 1
        confirmChoices = 1;
    end
    
    % Check if files already exist
    lastCheck = zeros(1, length(allFiles) );
    for fn = 1:length(allFiles)
        lastCheck(fn) = ( strcmp(allFiles(fn).name,csvOutputFile) || strcmp(allFiles(fn).name,matOutputFile) );
    end;
    lastCheck = max( lastCheck );
    
    if confirmChoices == 1
        if lastCheck == 0
            IDconfirm = 1;
        else
            % Indicate that a different ID number must be used
            warning = sprintf('The file already exists - please choose a different ID number.');
            waitfor( msgbox(warning,'IDinput') ); % Must close message to continue
        end
    end
    
end
drawnow; pause(0.05);  % this innocent line prevents the Matlab hang

% If they choose cancel, exit Matlab
if isempty(sel)
    exit();
end

% Return to original directory
cd(orig_dir);

% Cleans up workspace
clear prompt dlg_title num_lines IDnum allFiles IDconfirm boxSize ...
    confirmChoices stringPrompt sel Choices orig_dir lastCheck fn ...
    folderCheck promptResults;