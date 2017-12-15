%-----------------------------------------%
% An example trial for debugging purposes %
%-----------------------------------------%

% Skip Psychtoolbox synch tests
Screen('Preference', 'SkipSyncTests', 1);

% Add path for additional functions
orig_dir = cd('Internal_functions');
pathToFunctions = cd;
addpath(pathToFunctions);
cd(orig_dir);

% Set debugging options
debug = 0;
robotPar = [ 1.5, 2.5, 1, 1 1 ];

rng shuffle; % Random seed for rng

% Run script to initialize stimuli/responses
Stimulus_initialization

%%% Example trial %%%

% Set the proportion determining RMS contrast
rho = datasample( linspace( 0, 1, 11 ), 1 );

% Create noise patch
noiseWin = Noise_function(imSize,gaussWinNoise,0,1);
noiseWinTex = Screen('MakeTexture', window, noiseWin);

% Set up variables for each experimental trial
primeTimeCur = datasample( primeTimes, 1 );
fixTime = totalTime - primeTimeCur - targetTime - ...
    postMaskTime;
FT = [ fixTime, primeTimeCur, targetTime, postMaskTime ];

% Randomly select what the prime and target will be
currentPrime = datasample( [ 0 1 ], 1 );
currentTarget = datasample( [ 0 1 ], 1 );
% Based on target value, set rotation angle
thetaT = datasample( theta, 1 );
if currentTarget == 0
    thetaT = thetaT - 90;
end
rot = thetaT; % For additional scripts
% Set contrast for foil
% contrastF = datasample( C_RMS_F, 1 );
contrastF = .3;

% Create the gabor patch
[ gabor, contrastT ] = Overlaid_Gabors(imSize,rho,contrastF,thetaT,stripes,gaussWin,0);
gaborTex = Screen('MakeTexture', window, gabor);

PrimeYes = 1;
% NeitherPrime = datasample( [0,1], 1 );
NeitherPrime = 1;
% Run script
Gabor_priming_trial

% Save responses
Choice = resp;
ResponseTime = RT;
Accuracy = currentTarget == resp;

if ( Accuracy == 1 )
    DrawFormattedText(window, 'Correct!', 'center','center', [ 0 0 0 ] );
else
    DrawFormattedText(window, 'Wrong!', 'center','center', [ 0 0 0 ] );
end

% Flip to the screen
Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo.
KbStrokeWait;

% Clear the screen
clear Screen;
sca;