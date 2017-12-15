function [ C_RMS ] = RMS_contrast( intensity )
% Purpose:
%   Calculates the root mean square contrast for a set of intensity values.
% Arguments:
%   intensity - A row vector of grayscale intensity values.
% Returns;
%   The value of the root mean square contrast.
  
  MN = size( intensity, 2 );
  C_RMS = sqrt( sum( ( intensity - mean( intensity ) ).^2 )/MN );
  
end

