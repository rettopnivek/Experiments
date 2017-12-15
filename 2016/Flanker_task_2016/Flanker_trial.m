%-----------------------------------------%
% Single trial in an Eriksen flanker task %
%-----------------------------------------%

%{
Notes:
This script requires several variables to be defined in advance.
Use in conjuction with the 'Main_exp.m' script.
%}

% Loop through individual frames
sec0 = GetSecs; % Baseline timepoint
time_check = zeros(1, length( frame_index ) ); % Records stimulus presentation time
Screen('TextSize', window, stimFontSize); % Sets font size of stimulus
for frame = 1:numFrames
    
    % Fixation point
    if ( frame <= frame_index(1) )
        
        % Draw a black fixation point in the center of the screen
        Screen('DrawDots', window, [0,0], 4, [0 0 0], center, 1);
    end;
        
    % Interstimulus gap
    if ( frame > frame_index(1) && frame <= frame_index(2) )
        
        % Color the screen white
        Screen('FillRect', window, [ 1 1 1 ]);
        
    end;
    
    % Stimulis presentation
    if ( frame > frame_index(2) && frame <= frame_index(3) )
        
        % Display flankers and target
        if Flanker == 1
            % Displays the first stimulus
            Flanker_draw( stim1, stim1xPos, yPos(1), clr, window )
        end

        if Flanker == 2
            % Displays the second stimulus
            Flanker_draw( stim2, stim2xPos, yPos(2), clr, window )
        end

        if Target == 1
            % Displays the first stimulus
            Target_draw( stim1, stim1xPos, yPos(1), clr, window )
        end

        if Target == 2
            % Displays the second stimulus
            Target_draw( stim2, stim2xPos, yPos(2), clr, window )
        end
        
    end;
    
    % Flip to the screen
    Screen('Flip', window);
    
    % Check timing of stimuli
    for chk = 1:length(frame_index)
        if frame == frame_index(chk)
            time_check(chk) = GetSecs - sec0;
        end
    end
    
end;

% Color the screen white
Screen('FillRect', window, [ 1 1 1 ]);

% Flip to the screen
Screen('Flip', window);

% Record response and response time
[ RT, resp ] = getResponseMultiple(keyOptions(1:2),1:2, Response_interval);

if (RT > Response_interval)
    Accuracy = 0;
else
    Accuracy = resp == Target;
end
Slow = RT > RT_deadline;

% Determine feedback
if Slow==1
    string = 'Too slow';
elseif Accuracy==1
    string = 'Correct';
else
    string = 'Error';
end;

% Display feedback
DrawFormattedText(window, string, 'center','center', [ 0 0 0 ] );
Screen('Flip', window);
WaitSecs(Feedback_time);

% Inter-stimulus gap

% Color the screen white
Screen('FillRect', window, [ 1 1 1 ]);
Screen('Flip', window);
WaitSecs(Interstimulus_gap);
