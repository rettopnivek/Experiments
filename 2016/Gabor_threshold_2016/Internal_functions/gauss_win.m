function [ intensity ] = gauss_win( sigma, x_i, y_j )
% Purpose:
%   Calculates a two-dimensional gaussian filter.
% Arguments:
%   sigma - The standard deviation for the un-normalized gaussian density.
%   x_i   - The value of the x-axis coordinate(s).
%   y_j   - The value of the y-axis coordinate(s).
% Returns:
%   The grayscale intensity values (bounded between 0 and 1).

intensity = exp( -( (x_i.^2 + y_j.^2) ./ ( 2*sigma^2 ) ) );

end

