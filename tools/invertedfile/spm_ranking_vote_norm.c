/**
 * Ranking by votes
 * Input:
 * + array of inverted file
 * + list words of query image 
 * Return: ranked_list, vote score of images
 *
 *
 *
 */

#include "mex.h"
#include <math.h>

#include "inv_file_norm.h"

#define words prhs[1]

#define NI 6392

void getCandidates(float*, const invFile*, const int*, int, float);

int getSPMLevel(int x)
{
    int i;
    int lvs[4] = {1, 5, 21, 85};
    for(i = 0; i < 4; i++)
    {
        if (x + 1 <= lvs[i])
            return i;
    }
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    const invFile** inv         = *(invFile***) mxGetData(prhs[0]);
    size_t          nqSets      = mxGetNumberOfElements(prhs[1]); // number of query words set(5 set at pyramid level 1)
    float           *list_cand  = (float*)malloc(sizeof(float)*inv[0]->num_docs);
    int             *pOutId;
    float           *pOutVal;
    mwSize          dims[2];
    int             ncands = 0,
                    i,j,pos;
    
    // initialize candidates list
    for(i = 0; i < inv[0]->num_docs; i++) list_cand[i] = 0;

    printf("number of query word sets: %d\n",nqSets);
    
    for(i = 0; i < nqSets; i++) 
    {
        mxArray*    wPtr = mxGetCell(words,i);
        int*        q_w  = (int*)mxGetData(wPtr);
        size_t      n_w  = mxGetNumberOfElements(wPtr);
        
        if (wPtr != NULL)
        {
            // calculate SPM weight value
            int l = getSPMLevel(i);
            int L = getSPMLevel(nqSets-1);
            float weight = (float)1/( l==0 ? pow(2,L) : pow(2,L-l+1) ); 
            //printf("l = %d, L = %d, weight = %f\n",l,L,weight);
            getCandidates(list_cand, inv[i], q_w, n_w,weight);
        }
    }
    
    // count number of candidates
    for(i = 0; i < inv[0]->num_docs; i++)
            if (list_cand[i] > 0)
                ncands++;
    
    //printf("ncands: %d\n",ncands);
    // allocating output
    dims[0] = 1;
    dims[1] = ncands;
    plhs[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutId = (int*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, dims, mxSINGLE_CLASS, mxREAL);
    pOutVal = (float*)mxGetData(plhs[1]);

    // filtering output
    pos = 0;
    for(i = 0; i < inv[0]->num_docs; i++)
    {
        if(list_cand[i] > 0)
        {
            pOutId[pos]   = i + 1;
            pOutVal[pos]  = list_cand[i];
            pos ++;
            //printf("%f\n",list_cand[i]);
        }
    }
    
    // ranking - sort output
    quicksortf(pOutId, pOutVal, 0, ncands - 1); 
}

void getCandidates(float* list_cand, const invFile* inv, const int* q_words, int num_q_words, float spm_weight_val)
{
    int i, j;
    for(i=0; i < num_q_words; i++)
    {   
        int w = q_words[i] - 1;
        if (inv->size_pw[w] >0)
        {
            for(j=0; j < inv->size_pw[w]; j++)
            {
                int     x    = inv->inv_file[w][j].id;
                float   norm = inv->inv_file[w][j].val;
                list_cand[x] += 1*spm_weight_val;
            }
        }
    }
}

