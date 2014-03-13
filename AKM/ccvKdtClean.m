function ccvKdtClean(kdt)
% CCVKDTCLEAN cleans the memory for the input kd-tree
% 
% INPUTS
% ------
% kdt       - the input kd-tree, output from CCVKDTCREATE
%
% OUTPUTS
% -------
%
% See also ccvKdtKnn ccvKdtCreate
%

% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010

%call the mex file
mxKdtClean(kdt);

