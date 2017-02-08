/* FOR MATLAB ONLY !
 * Function inv_search_c(invfile,data): get candidates list from input data
 * params:
 * - invfile (invFile)          : inverted file (created by inv_create_c.c || inv_create_norm_c.c)
 * - data    (vector 1xN)       : a document contains a list of words
 * returns:
 * - candidates list (vector )  : list of candidates documents id
*/

#include "mex.h"
#include "inv_file_norm.h"

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    const invFile*  inv     = *(invFile**) mxGetData(prhs[0]);      // pointer to input inverted file
    int*            qwords  = (int*)mxGetPr(prhs[1]);                     // pointer to input data    (document - words list)
    int             nqwords = (int)mxGetNumberOfElements(prhs[1]);  // lenght of input data     (number of words)
    float*          qhist;
    mwSize          dims[2];
    float*          candidates;     // pointer store output candidates list
    int             ncands = 0;     // number of output candidates
    int*            pOutId;
    float*          pOutVal;           // pointer to output
    int             i = 0,
                    j = 0;
    int             pos;
    
    hist(&qhist,qwords,nqwords,inv->num_words);
    
    candidates = (float*)malloc(sizeof(float)*inv->num_docs);
    for(i = 0; i < inv->num_docs; i++) candidates[i] = 0;
    
    for(i = 0; i < inv->num_words; i++)
    {   
        if (qhist[i] > 0)
        {
            if (inv->size_pw[i] > 0)
            {
                for(j=0; j < inv->size_pw[i]; j++)
                {
                    int   x    = inv->inv_file[i][j].id;
                    float norm = inv->inv_file[i][j].val;
                    candidates[x] += (norm < qhist[i] ? norm : qhist[i]); // normalize histogram intersection
                }
            }
        }
    }
    
//     for(i = 0; i < nqwords; i++)
//     {   
//         int w = qwords[i] - 1;
//         if (inv->size_pw[w] > 0)
//         {
//             for(j=0; j < inv->size_pw[w]; j++)
//             {
//                 int x = inv->inv_file[w][j].id;
//                 candidates[x] ++;
//             }
//         }
//     }
    
    for(i = 0; i < inv->num_docs; i++) if (candidates[i] > 0) ncands ++;
    
    dims[0] = 1;
    dims[1] = ncands;
    plhs[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutId = (int*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, dims, mxSINGLE_CLASS, mxREAL);
    pOutVal = (float*)mxGetData(plhs[1]);
    
    pos = 0;
    for(i = 0; i < inv->num_docs; i++)
    {
        if (candidates[i] >0)
        {
            pOutId[pos] = i + 1;
            pOutVal[pos] = candidates[i];
            pos ++;
        }
    }
    
    quicksortf(pOutId, pOutVal, 0, ncands-1);
}