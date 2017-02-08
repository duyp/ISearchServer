function ccvInvFileClean(ivf)
% CCVINVFILECLEAN cleans the memory of the input ivf
%
% INPUTS
% ------
% ivf       - the input structure
%
% OUTPUTS
% -------
%
% See also ccvInvFileCompStats ccvInvFileSave ccvInvFileInsert
% ccvInvFileLoad ccvInvFileSearch
%

% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010

%call the mex file
mxInvFileClean(ivf);

