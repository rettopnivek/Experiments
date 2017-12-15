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
    
    prompt = {'Please enter subject ID number:'};
    dlg_title = 'ID input';
    num_lines = 1;
    IDnum = inputdlg(prompt,dlg_title,num_lines);
    
    % If they choose cancel, exit Matlab
    if isempty(IDnum)
        exit();
    end
    
    sessionConfirm = 0;
    while sessionConfirm == 0
        
        prompt = {'Please enter session number:'};
        dlg_title = 'IDinput';
        num_lines = 1;
        SessionNum = inputdlg(prompt,dlg_title,num_lines);
        
        % If they choose cancel, exit Matlab
        if isempty(SessionNum)
            exit();
        end
        
        if str2num( SessionNum{1} ) > 0 && str2num( SessionNum{1} ) < 5
            sessionConfirm = 1;
        else
            % Indicate that a different ID number must be used
            warning = sprintf('Incorrect session number - please pick a number between 1 and 4');
            waitfor( msgbox(warning,'IDinput') ); % Must close message to continue
        end
    end
    
    % Create output file names
    csvOutputFile = strcat('Subject_',IDnum,'_',SessionNum,'.csv');
    matOutputFile = strcat('Subject_',IDnum,'_',SessionNum,'.mat');
    matProgressFile = strcat('Subject_',IDnum,'_post.mat');
    demographicsFile = strcat('Subject_',IDnum,'_demographics.txt');
    
    % Define the initial prompt
    stringPrompt = [ {sprintf('Are these the desired filenames?')} ...
        {sprintf( [ csvOutputFile{1} ' and ' matOutputFile{1} '.' ] )} ...
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
        lastCheck(fn) = ( strcmp(allFiles(fn).name,csvOutputFile{1}) || strcmp(allFiles(fn).name,matOutputFile{1}) );
    end;
    lastCheck = max( lastCheck );
    
    if confirmChoices == 1
        if lastCheck == 0
            IDconfirm = 1;
        else
            % Indicate that a different ID number must be used
            warning = sprintf('The file already exists - please choose a different ID or session number.');
            waitfor( msgbox(warning,'IDinput') ); % Must close message to continue
        end
    end
    
end

% If they choose cancel, exit Matlab
if isempty(sel)
    exit();
end
drawnow; pause(0.05);  % this innocent line prevents the Matlab hang

% Return to original directory
cd(orig_dir);

% Convert sessionNumber from a string to a number
SessionNum = str2num( SessionNum{1} );
% Save subject number
SubjNum = str2num( IDnum{1} );

% Cleans up workspace
clear prompt dlg_title IDnum num_lines allFiles IDconfirm boxSize ...
    confirmChoices stringPrompt sel Choices orig_dir lastCheck fn ...
    folderCheck sessionConf;