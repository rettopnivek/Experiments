function [ A, LL, UL ] = Contrast_to_amp( X, Y, C_RMS, theta, lambda )
% Purpose:
%   Given a RMS contrast value, calculates the corresponding amplitude of 
%   the sine wave for a gabor patch.
% Arguments:
%   X      - A row vector with the values of the x-axis coordinates.
%   Y      - A row vector with the values of the y-axis coordinates.
%   C_RMS  - The RMS contrast value.
%   theta  - The angle of rotation for the gabor patch.
%   lambda - The frequency, the number of oscillations (or bands) within a 
%            single unit. 
% Returns:
%   The amplitude of the sine wave, along with smallest and largest values 
%   that the RMS contrast can take given the parameters for the gabor
%   patch.
  
  	M = sqrt( size( X, 2) );
	MN = M*M;
	
	beta_ij = f_Theta( lambda, theta, 0, X, Y ) - .5;
	part_1 = sqrt( sum( ( beta_ij - sum( beta_ij )/MN ).^2 )/MN );
	
	% Determine boundaries
	intensity = beta_ij + .5; % A = 1
	UL = RMS_contrast( intensity );
	LL = 0; % A = 0
	
	% Restrict to be within boundaries
	C_RMS = min( C_RMS, UL );
	C_RMS = max( LL, C_RMS );
    
    A = C_RMS/part_1;
    
end