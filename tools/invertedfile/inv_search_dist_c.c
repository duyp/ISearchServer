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
    const invFile*  inv     = *(invFile**)mxGetData(prhs[0]);      // pointer to input inverted file
    int*            qwords  = (int*)mxGetPr(prhs[1]);                     // pointer to input data    (document - words list)
    int             nqwords = (int)mxGetNumberOfElements(prhs[1]);  // lenght of input data     (number of words)
    invNode*        qwords_hist;    // histogram of input document (query words)
    float*          qhist;
    int             hist_size;
    mwSize          dims[2];
    int             *pOutId;        // pointer to output (id and value)
    float           *pOutVal;                       
    float           *candidates = (float*)malloc(sizeof(float)*inv->num_docs);     // pointer store output candidates list
    int             ncands  = 0;     // number of output candidates
    int             i, j, k, pos;
    
    for(i = 0; i < inv->num_docs; i++)
        candidates[i] = 0.0f;
    
    hist(&qhist,qwords,nqwords,inv->num_words);
    
    //hist_compress(&qwords_hist, &hist_size, qwords, nqwords, inv->num_words); // make input document histogram
    
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
                    float dist = norm - qhist[i];
                    dist = dist>=0?dist:-dist;
                    candidates[x] += dist;
                }
            }
        }
    }
    
    // use compressed
//     for(i = 0; i < hist_size; i++)
//     {   
//         int w = qwords_hist[i].id;
//         if (inv->size_pw[w] > 0)
//         {
//             for(j=0; j < inv->size_pw[w]; j++)
//             {
//                 int     x       = inv->inv_file[w][j].id;
//                 float   norm    = inv->inv_file[w][j].val;
//                 float dist = norm - qwords_hist[i].val;
//                 dist = dist>=0?dist:-dist;
//                 candidates[x] += dist;
//             }
//         }
//     }
    
    // Tinh: Q co I k, Q k I co
//     for(i = 0; i < inv->num_docs; i++)
//     {
//         if (candidates[i] >0)
//         {
//             char docFlag[1000000] = {0};
//             int n = inv->docs[i].size;
//             for(j = 0; j < n; j++)
//             {
//                 int w = inv->docs[i].words[j];
//                 docFlag[w] = 1;
//                 if(qhist[w] == 0) // Q k I co
//                 {
//                     candidates[i] += (float)1/n; // increase distance value
//                 }
//             }
//             
//             for(k = 0; k <nqwords; k++)
//             {
//                 int w = qwords[k] - 1;
//                 if (docFlag[w] == 0)     // Q co I k
//                 {
//                     candidates[i] += qhist[w];
//                 }
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
    
    quicksortf_dist(pOutId, pOutVal, 0, ncands-1);
    
}
    