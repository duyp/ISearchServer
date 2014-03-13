function ivf = ccvInvFileLoad(file)
% CCVINVFILELOAD loads the structure from disk
%
% INPUTS
% ------
% file      - the file name
%
% OUTPUTS
% -------
% ivf       - the output structure
%
% See also ccvInvFileCompStats ccvInvFileSave ccvInvFileInsert
% ccvInvFileClean ccvInvFileSearch
%

% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010

%call the mex file
ivf = mxInvFileLoad(file);

