function ccvLshSave(lsh, file)
% CCVLSHSAVE saves an LSH index to file
%
% INPUTS
% ------
% lsh       - the input lsh
% file      - the input file name
%
% OUTPUTS
% -------
%
% See also ccvLshClean ccvLshCreate ccvLshInsert ccvLshLoad ccvLshSearch
% ccvLshBucketId ccvLshFuncVal ccvLshStats ccvLshBucketPoints ccvLshKnn
 
% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010

%call the mex file
mxLshSave(lsh, file);

