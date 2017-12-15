%---------------------%
% Experimental blocks %
%---------------------%

% Define a matrix to store the final results
allResults = [];

% Define variables to keep track of performance
ptsOverall = 0;
accuracyOverall = 0;
timeOverall = 0;

% Loop through blocks
for blck = 0:(nBlocks-1)
    
    % Number of trials per condition
    if blck==0
        % Practice trials
        nTrials = nTrialsByBlocks(1,:);
        curDeadline = start_deadline;
    else
        % Experimental trials
        nTrials = nTrialsByBlocks(2,:);
    end
    
    % Define a variable indicating congruency
    % 1 = congruent, 0 = incongruent
    Congruent = [ ones(1, sum( nTrials(1:2) ) ), ...
                  zeros(1, sum( nTrials(3:4) ) ) ];
    % Recall that 1 = S, 2 = H
    % Create variable indicating the current target
    Targets = [ ones(1, nTrials(1))*2, ... % CH
                ones(1, nTrials(1)), ...   % CS
                ones(1, nTrials(1))*2, ... % IH
                ones(1, nTrials(1)) ];     % IS
    
    % Shuffle the order of the trial presentation
    order = randperm( sum( nTrials ) );

    % Define matrix to store results
    % 1) RT, 2) Choice, 3) Correct, 4) Accuracy, 5) Slow, 6) Congruent, 
    % 7) Block, 8) Points, 9 - 11) Stimulus timing
    results = zeros( sum( nTrials ), 11 );
    
    % Introduction to each block
    
    if blck == 0
        string = 'Practice block';
    else
        string = [ 'Block ' num2str(blck) ];
    end
    
    if blck == round( (nBlocks - 1)/2 )
        string2 = 'Feel free to pause for a bit if you are tired';
    else
        string2 = ' ';
    end
    
    instruct = num2str( ones(2,1) ); % Create a cell string array
    instruct = cellstr(instruct);
    instruct{1} = string;
    instruct{2} = string2;
    instruct{3} = ' ';
    instruct{4} = 'Press any key to begin';
    lenIns = length(instruct);
    
    % Display the instructions
    displayInstruct % Call separate Matlab script
        
    % Loop through trials
    for trl = 1:sum(nTrials)

        % Forthcoming (adaptive RT)
        % RT_deadline = 0.800; % Set response time deadline (in seconds)
        RT_deadline = min( curDeadline, Response_interval );

        % Set flankers and target
        Target = Targets( order(trl) );
        if Congruent( order(trl) )==1
            % Set flankers to match target
            Flanker = Target;
        else
            % Set flankers to oppose target
            Flanker = 3 - Target;
        end

        % Run script generating a single flanker trial
        Flanker_trial
        
        % Determine the points earned
        if Slow==1
            ptsEarned = ptsSlow;
        elseif Accuracy==1
            ptsEarned = ptsCorrect;
        else
            ptsEarned = ptsError;
        end;

        % Record the results
        % 1) RT, 2) Choice, 3) Correct, 4) Accuracy, 5) Slow, 
        % 6) Congruent, 7) Block, 8) Points, 
        % 9 - 11) Stimulus timing
        results(trl,:) = [ RT, resp, Target, Accuracy, Slow, ...
                           Congruent( order(trl) ), blck, ptsEarned, ...
                           time_check ];
    
    end
    
    % Sum up progress at end of block
    ptsAverage = sum( results(:,8) );
    ptsOverall = ptsOverall + ptsAverage;
    
    % Feedback on end of block performance
    Block_feedback
    
    % Save the results for the current block
    allResults = [ allResults; results ];
    
    % Set new RT deadline
    curDeadline = mean( results(:,1) ) + std( results(:,1) )*.5;
    curDeadline = min( start_deadline, curDeadline );
    
        % Reset the score to 0 after the practice block
    if blck == 0
        ptsOverall = 0;
    end
end