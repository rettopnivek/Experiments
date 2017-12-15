%--------------------%
% Condition creation %
%--------------------%

% Set the number of trials per condition
nTrialsCur = 80;

% 5 contrast values x 3 prime types x 2 prime durations
% Each conditions consists of 1/2 left, 1/2 right

% Create matrix of conditions, where...
% 1) contrastF - contrast for the foil
% 2) primeTime - the duration of the prime
% 3) primeYes  - the type of prime ( 0 = rotated prime, 1 = neither primed )
% 4) target    - the target rotation ( 0 = left, 1 = right )
% 5) prime     - the prime rotation ( 0 = left, 1 = right )
% 6) condition - the index for the priors/posteriors with the adaptive part

col_1 = reshape( repmat( C_RMS_F, nTrialsCur*3*2, 1 ), nTrialsCur*30, 1 );
col_2 = reshape( repmat( primeTimes, nTrialsCur*3, 1 ), nTrialsCur*3*2, 1 );
col_2 = repmat( col_2, 5, 1 );
col_3 = reshape( repmat( [ 0 0 1 ], nTrialsCur, 1 ), nTrialsCur*3, 1 );
col_3 = repmat( col_3, 5*2, 1 );
col_4 = reshape( repmat( [ 0 1 ], nTrialsCur/2, 1 ), nTrialsCur, 1 );
col_4 = repmat( col_4, 30, 1 );
col_5 = reshape( repmat( [ 1 0 0 1 0 1 ], nTrialsCur/2, 1 ), nTrialsCur*3, 1 );
col_5 = repmat( col_5, 5*2, 1 );
col_6 = reshape( repmat( 1:(5*3*2), nTrialsCur, 1 ), nTrialsCur*30, 1 );

allConditions = [ col_1 col_2 col_3 col_4 col_5 col_6 ];
% clear col_1 col_2 col_3 col_4 col_5 col_6;

% Define the parameters for simulating responses across the myriad
% conditions
all_robotPar = [ repmat( 3, 30, 1 ), ...
    reshape( repmat( abs( linspace( -2, -.75, 5 ) ), 6, 1 ), 30, 1 ), ...
    ones( 30, 1 ), ones( 30, 1 ), zeros( 30, 1 ) ];

% Number of blocks
nBlocks = 24;
% Number of trials per block
nTrialsBlock = size( allConditions, 1 )/nBlocks;
% Randomly shuffle presentation order
ord = randperm( size( allConditions, 1 ) );

% For exemplar purposes, have a reduced version with less conditions
if reduced == 1
    
    col_1 = repmat( datasample( C_RMS_F, 1 ), nTrialsCur*3, 1 );
    col_2 = repmat( datasample( primeTimes, 1 ), nTrialsCur*3, 1 );
    col_3 = reshape( repmat( [ 0 0 1 ], nTrialsCur, 1 ), nTrialsCur*3, 1 );
    col_4 = reshape( repmat( 0:1, nTrialsCur*(3/2), 1 ), nTrialsCur*3, 1 );
    col_5 = reshape( repmat( [ 0 1 0 1 0 0 ], nTrialsCur/2, 1 ), nTrialsCur*3, 1 );
    col_6 = reshape( repmat( [ 1:3 1:3 ], nTrialsCur/2, 1 ), nTrialsCur*3, 1 );
    
    allConditions = [ col_1 col_2 col_3 col_4 col_5 col_6 ];
    clear col_1 col_2 col_3 col_4 col_5 col_6;
    
    all_robotPar = [ 1.5, 2.5, 1, 1, 0; ...
        2.0, 1.5, 1, 1, 0; ...
        1.0, 3.0, 1, 1, 0 ];
    
    % Number of blocks
    nBlocks = 3;
    % Number of trials per block
    nTrialsBlock = size( allConditions, 1 )/nBlocks;
    % Randomly shuffle presentation order
    ord = randperm( size( allConditions, 1 ) );
    
end

% Total number of conditions
nCond = max( unique( allConditions(:,6) ) );
