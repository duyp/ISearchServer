/**
 * Ranking by votes
 * Input:
 * + inverted file
 * + list words of query image 
 * Return: vote score of images, ranked_list
 *
 *
 *
 */

#include "mex.h"
#include "inv_file_1.h"

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    const invFile*  inv     = *(invFile**) mxGetData(prhs[0]);      // pointer to input inverted file
    int*            qwords  = mxGetPr(prhs[1]);                     // pointer to input data    (document - words list)
    int             nqwords = (int)mxGetNumberOfElements(prhs[1]);  // lenght of input data     (number of words)
    mwSize          dims[2];
    int*            candidates;     // pointer store output candidates list
    int             ncands = 0;     // number of output candidates
    int             *pOutId,        // pointer to output (id and value)
                    *pOutVal; 
    int             ndocs = 5063;
    int             i = 0,
                    j = 0;
    int             pos;
    
    candidates = (int*)malloc(sizeof(int)*ndocs);
    for(i = 0; i < ndocs; i++) candidates[i] = 0;
    
    for(i=0; i < nqwords; i++)
    {   
        int w = qwords[i] - 1;
        if (inv->flag[w] == 1)
        {
            for(j=0; j < inv->size_pw[w]; j++)
            {
                int x = inv->inv_file[w][j].id;
                candidates[x] ++;
            }
        }
    }
    
    for(i = 0; i < ndocs; i++) if (candidates[i] > 0) ncands ++;

    dims[0] = 1;
    dims[1] = ncands;
    plhs[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutId = (int*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutVal = (int*)mxGetData(plhs[1]);
       
    pos = 0;
    for(i = 0; i < ndocs; i++)
    {
        if (candidates[i] >0)
        {
            pOutId[pos] = i + 1;
            pOutVal[pos] = candidates[i];
            pos ++;
        }
    }
    
    quicksort(pOutId, pOutVal, 0, ncands-1);
    
    //////////////////////// OLD VERSION
    
//     const invFile* inv = *(invFile**) mxGetData(prhs[0]);
//     
//     int* q_words = mxGetPr(prhs[1]);     
//     int num_q_words = mxGetNumberOfElements(prhs[1]);
//     int* count = (int*)malloc(sizeof(int)*num_q_words);
//     
//     int** matrix_cand = (int**)malloc(sizeof(int*)*num_q_words);
//     
//     mwSize dims[2];
//     
//     int *cands, *ccount;
//     int *pOutId, *pOutVal;
//     
//     int pos = 0;
//     int ncands = 0;
//     
//     int* candidates = (int*)malloc(sizeof(int)*NI);
//     
//     int i = 0, 
//         j = 0;
//     
//     if(inv == NULL) return;
//     
//     for(i = 0; i < NI; i++) candidates[i] = 0;
//     
//     for (i = 0; i < num_q_words; i++)
//     {
//         int w = q_words[i]-1;
//         if(inv->flag[w] == 1)
//         {
//             int* list_im_id = inv->inv_file[w];
//             matrix_cand[i] = list_im_id;
//             count[i] = inv->size_pw[w];
//         }
//     }
//     
//     // list candidate return
//     for(i=0; i < num_q_words; i++)
//     {   
//         if (inv->flag[q_words[i]-1] == 1)
//         {
//             for(j=0; j < count[i]; j++)
//             {
//                 int x = matrix_cand[i][j];
//                 candidates[x] ++;
//             }
//         }
//     }
// 
//     for(i = 0; i < NI; i++)
//         if (candidates[i] > 0) 
//             ncands ++;
//     
//     cands = (int*)malloc(sizeof(int)*ncands);
//     ccount = (int*)malloc(sizeof(int)*ncands);
//     
//     for(i = 0; i < NI; i++)
//     {
//         if (candidates[i] >0)
//         {
//             cands[pos] = i + 1;
//             ccount[pos] = candidates[i];
//             pos ++;
//         }
//     }
//     
//     dims[0] = 1;
//     dims[1] = ncands;
//     plhs[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
//     pOutId = (int*)mxGetData(plhs[0]);
//     plhs[1] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
//     pOutVal = (int*)mxGetData(plhs[1]);
//    
//     quicksort(cands, ccount, 0, ncands-1);
//  
//    for(i = 0; i < ncands; i++)
//    {
//        pOutId[i] = cands[i];
//        pOutVal[i] = ccount[i];
//    }
}