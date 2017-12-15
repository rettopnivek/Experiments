%----------------------------------------------------%
% Example of adaptive design script for psychometric %
% for psychometric curve determination               %
%----------------------------------------------------%

% Skip Psychtoolbox synch tests
Screen('Preference', 'SkipSyncTests', 1);

% Add path for additional functions
orig_dir = cd('Internal_functions');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Set debugging options
debug = 1;
all_robotPar = [ 1.5, 2.5, 1, 1, 0; ...
             2.0, 1.5, 1, 1, 0; ...
             1.0, 3.0, 1, 1, 0 ];

rng shuffle; % Random seed for rng

% Run script to initialize stimuli/responses
Stimulus_initialization

% Set the number of trials per condition
nTrialsCur = 160;

% Create matrix of conditions, where...
% 1) contrastF - contrast for the foil
% 2) primeTime - the duration of the prime
% 3) primeYes  - the type of prime ( 0 = rotated prime, 1 = neither primed )
% 4) target    - the target rotation ( 0 = left, 1 = right )
% 5) prime     - the prime rotation ( 0 = left, 1 = right )
% 6) condition - the index for the priors/posteriors with the adaptive part

col_1 = repmat( datasample( C_RMS_F, 1 ), nTrialsCur*3, 1 );
col_2 = repmat( datasample( primeTimes, 1 ), nTrialsCur*3, 1 );
col_3 = reshape( repmat( [ 0 0 1 ], nTrialsCur, 1 ), nTrialsCur*3, 1 );
col_4 = reshape( repmat( 0:1, nTrialsCur*(3/2), 1 ), nTrialsCur*3, 1 );
col_5 = reshape( repmat( [ 0 1 0 1 0 0 ], nTrialsCur/2, 1 ), nTrialsCur*3, 1 );
col_6 = reshape( repmat( [ 1:3 1:3 ], nTrialsCur/2, 1 ), nTrialsCur*3, 1 );

allConditions = [ col_1 col_2 col_3 col_4 col_5 col_6 ];
clear col_1 col_2 col_3 col_4 col_5 col_6;

%%% Initialize variables for measurement model estimation

% Total number of conditions
nCond = max( unique( allConditions(:,6) ) );

x_lev = zeros( nCond, 50 );
x = zeros( 1, nCond );
for i = 1:nCond
    x_lev(i,:) = linspace( log( ...
        unique( allConditions( allConditions(:,5) == 1, 1 ) ) ), ...
        log(.5), 50 );
    % Initialize contrast level for target
    x(i) = x_lev( i, round(size(x_lev,2)/2) );
    
end

% Grid precision
alpha_prec = 50;
beta_prec = 50;
% Vector of parameter values
boundaries = [ 0, 7, 0, 7 ];
% Parameter grid
alpha_val = linspace( boundaries(1), boundaries(2), alpha_prec );
beta_val = linspace( boundaries(1), boundaries(2), beta_prec );

% Priors
priors = [ 2, 6, 2, 6 ];

alpha_prior = zeros( nCond, alpha_prec );
beta_prior = zeros( nCond, beta_prec );
for i = 1:nCond
    alpha_prior(i,:) = normpdf( alpha_val, priors(1), priors(2) ) ./ ...
        ( normcdf( 7, priors(1), priors(2) ) - ...
        normcdf( 0, priors(1), priors(2) ) );
    beta_prior(i,:) = normpdf( beta_val, priors(3), priors(4) ) ./ ...
        ( normcdf( 7, priors(3), priors(4) ) - ...
        normcdf( 0, priors(3), priors(4) ) );
end
% Initialize array for posterior
all_posteriors = zeros( alpha_prec, beta_prec, nCond );

% Number of blocks
nBlocks = 6;
% Number of trials per block
nTrialsBlock = size( allConditions, 1 )/nBlocks;
% Randomly shuffle presentation order
ord = randperm( size( allConditions, 1 ) );

% Matrix to record results
% 1) RT, 2) Choice, 3) Accuracy 4) Target,
% 5) Prime 6) Prime duration 7) Foil contrast 8) Target contrast
% 9) Proportion 10) Rotation angle 11) Block
results = zeros( nTrialsCur, 11);

inc = 0;
for blck = 1:nBlocks
    
    % Current block
    DrawFormattedText(window, [ 'Block ' num2str(blck) ], 'center','center', [ 0 0 0 ] );
    Screen('Flip', window);
    WaitSecs(.5);
    
    for trl = 1:nTrialsBlock
        
        inc = inc + 1; % Increment presentation order
        
        % Set contrast for foil
        contrastF = allConditions( ord(inc), 1 );
        % Set prime duration
        primeTimeCur = allConditions( ord(inc), 2 );
        % Set current condition
        curCnd = allConditions( ord(inc), 6 );
        
        % Extract parameters for robot
        if debug == 1
            robotPar = all_robotPar(curCnd,:);
        end
        
        % Set the proportion determining RMS contrast
        rho = (exp(x(curCnd))-contrastF)/(.5-contrastF);
        
        % Create noise patch
        noiseWin = Noise_function(imSize,gaussWinNoise,0,1);
        noiseWinTex = Screen('MakeTexture', window, noiseWin);
        
        fixTime = totalTime - primeTimeCur - targetTime - ...
            postMaskTime;
        FT = [ fixTime, primeTimeCur, targetTime, postMaskTime ];
        
        % Set the rotation direction for the prime and target
        currentTarget = allConditions( ord(inc), 4 );
        currentPrime = allConditions( ord(inc), 5 );
        % Set rotation angle
        thetaT = datasample( theta, 1 );
        if currentTarget == 0
            thetaT = -thetaT;
        end
        rot = thetaT; % For additional scripts
        
        % Create the gabor patch
        [ gabor, contrastT ] = Overlaid_Gabors(imSize,rho,contrastF,thetaT,stripes,gaussWin,0);
        gaborTex = Screen('MakeTexture', window, gabor);
        
        PrimeYes = 1;
        NeitherPrime = allConditions( ord(inc), 3 );
        % Run script
        Gabor_priming_trial
        
        % Save responses
        Choice = resp;
        ResponseTime = RT;
        Accuracy = currentTarget == resp;
        y = Accuracy; % For adaptive aspect
        
        results(trl,:) = [ RT resp Accuracy currentTarget currentPrime ...
            primeTimeCur contrastF contrastT rho rot blck ];
        
        if ( Accuracy == 1 )
            DrawFormattedText(window, 'Correct!', 'center','center', [ 0 0 0 ] );
        else
            DrawFormattedText(window, 'Wrong!', 'center','center', [ 0 0 0 ] );
        end
        
        % Flip to the screen
        Screen('Flip', window);
        WaitSecs(feedbackTime);
        
        % Determine the posterior using a grid approximation method
        [ posterior, alpha_post, beta_post ] = grid_approx( y, x(curCnd), ...
            alpha_val, beta_val, alpha_prior(curCnd,:), beta_prior(curCnd,:) );
        % Update posterior grid
        all_posteriors( :, :, curCnd ) = posterior;
        
        % Update the priors using the new marginalized posteriors for
        % alpha/beta
        alpha_prior(curCnd,:) = alpha_post;
        beta_prior(curCnd,:) = beta_post;
        
        % Design optimization
        [ ~, new_x ] = utility_f( y, x_lev(curCnd,:), alpha_val, beta_val, ...
            alpha_prior(curCnd,:), beta_prior(curCnd,:) );
        
        % Get the new sensory level to use in the next trial
        x(curCnd) = new_x;
        
    end
    
end

%{
subplot(1,2,1);
plot( alpha_val, alpha_prior );
subplot(1,2,2);
plot( beta_val, beta_prior );

figure();
alpha_grid = meshgrid( alpha_val )';
beta_grid = meshgrid( beta_val );
for i = 1:nCond
    posterior = all_posteriors(:,:,i);
    vec_post = posterior(:);
    [ ~, I ] = max( vec_post );
    % Indices for parameter matrices
    [aI, bI ] = ind2sub( size(posterior), I );
    subplot(1,3,i);
    % Contour plot of posterior
    contourf(beta_grid,alpha_grid,all_posteriors(:,:,i));
    hold on;
    
    % Maximum
    subplot(1,3,i);
    plot( beta_grid(aI,bI), alpha_grid(aI,bI), ...
        'r.','MarkerSize',20 );
    hold on;
    % Robot parameters
    subplot(1,3,i);
    plot( all_robotPar(i,2), all_robotPar(i,1), ...
        'b.','MarkerSize',20 );
    % Prior
    subplot(1,3,i);
    plot( priors(3), priors(1), ...
        'g.','MarkerSize',20 );
end
%}

% End of example
DrawFormattedText(window, 'Fin', 'center','center', [ 0 0 0 ] );
Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the example.
KbStrokeWait;

% Clear the screen.
sca;
