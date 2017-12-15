function [ intensity, C_RMS_T ] = Overlaid_Gabors( imSize, rho, C_RMS_F, thetaT, lambda, sigma, show )
% Purpose:
%   Function to generate a gabor patch overlaid with visual white noise.
% Arguments:
%   imSize  - The size in pixels of the final (square) image.
%   rho     - The proportion determining the desired RMS contrast of the 
%             target grating.
%   C_RMS_F - The RMS contrast of the foil grating.
%   thetaT  - The orientation in degrees (0 = straight, + rotated 
%             clockwise, rotated counter-clockwise). Second grating is 
%             90 degrees counter-clockwise from the first.
%   lambda - The frequency of the sine wave, determining the number of 
%            stripes present for each grating.
%   sigma  - Standard deviation for the gaussian filter (larger values
%            lead to more of the gabor patch being exposed).
%   show   - Set to 1 to generate a figure displaying the output.

% x-axis coordinates (centered at 0)
X = linspace( -.5, .5, imSize );
X = repmat( X, imSize, 1 );
X = reshape( X, 1, imSize*imSize );
% y-axis coordinates (centered at 0)
Y = linspace( -.5, .5, imSize );
Y = repmat( Y, 1, imSize );

% Angle of target and foil
thetaF = thetaT - 90;
% Convert to radians
thetaT = DegreesToRadians(thetaT);
thetaF = DegreesToRadians(thetaF);

% Determine constants
MN = size( X, 2 ); % Total number of coordinates
beta_ij_T = f_Theta(lambda,thetaT,0,X,Y) - .5;
beta_ij_F = f_Theta(lambda,thetaF,0,X,Y) - .5;

% Foil amplitude
[ A_F LL, UL ] = Contrast_to_amp( X, Y, C_RMS_F, thetaF, lambda );
% Target amplitude
C_RMS_T = (UL - C_RMS_F)*rho + C_RMS_F;
A_T = Contrast_to_amp( X, Y, C_RMS_T, thetaT, lambda );

% Calculate grid of intensity values

intensity_T = A_T*beta_ij_T + .5; % Intensity for target
intensity_F = A_F*beta_ij_F + .5; % Intensity for foil
intensity = .5*intensity_T + .5*intensity_F; % Mixture of two
intensity = 2*(intensity - .5); % Add gaussian window
gw = gauss_win( sigma, X, Y );
intensity = (intensity .* gw)/2 + .5;
intensity = vec2mat( intensity, imSize ); % Convert to matrix

if show == 1
    colormap gray(256); % use gray colormap (0: black, 1: white)
    imagesc( intensity, [0 1] );
end

end