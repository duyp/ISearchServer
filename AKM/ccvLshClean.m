function ccvLshClean(lsh)
% CCVLSHCLEAN cleans the input lsh
%
% INPUTS
% ------
% lsh       - the input lsh
%
% OUTPUTS
% -------
%
% See also ccvLshCreate ccvLshInsert ccvLshLoad ccvLshSave ccvLshSearch
% ccvLshBucketId ccvLshFuncVal ccvLshStats ccvLshBucketPoints ccvLshKnn

% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010


%call the mex file
mxLshClean(lsh); 

