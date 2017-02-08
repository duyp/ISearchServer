#include "mex.h"

#include "inv_file.h"

#define MAX_COUNT   100
#define NUM_WORDS   1000000
#define dataIn      prhs[0]

#define TRUE        1
#define FALSE       0

int fill_inv_i(const mxArray*,int**,int*);

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    size_t      nwordset = 0;
    mxArray*    out;
    invFile**   invFileOut;
    int***      p_data;
    int**       p_size;
    int         i, count = 0;
    unsigned long sum_size = 0;
    
    if (mxIsCell(dataIn) && (nwordset = mxGetNumberOfElements(dataIn)) > 0)
    {
        printf("nwordset: %d\n",nwordset);
    }
    else return;
    
    p_data      = (int***)malloc(sizeof(int**)*nwordset);
    p_size      =  (int**)malloc(sizeof(int*)*nwordset);  
    invFileOut  = (invFile**)malloc(sizeof(invFile*)*nwordset);
    
    for(i = 0; i < nwordset; ++i)
    {
        const mxArray* wordsPtr = mxGetCell(dataIn, i);
        if (wordsPtr != NULL)
        {
            int ndocs;
            printf("wordset[%d]\n",i);
            p_data[i]   = (int**)malloc(sizeof(int*)*NUM_WORDS);
            p_size[i]   = (int*)malloc(sizeof(int)*NUM_WORDS);  

            ndocs = fill_inv_i(wordsPtr, p_data[i], p_size[i]);

            invFileOut[i]               = (invFile*)malloc(sizeof(invFile));
            invFileOut[i]->num_words    = NUM_WORDS;
            invFileOut[i]->num_docs     = ndocs;
            invFileOut[i]->inv_file     = p_data[i];
            invFileOut[i]->size_pw      = p_size[i];
            //printf("total size of inverted file: %.0f\n", getInvSize(invFileOut[i]));
            sum_size += getInvSize(invFileOut[i]);
        }
    }

    printf("done load and fill data! Inverted file Size: %lu\n",sum_size);
    
    out = mxCreateNumericMatrix(1,1,mxINDEX_CLASS,mxREAL);
    *(invFile***) mxGetPr(out) = invFileOut;
    plhs[0] = out;
}

int fill_inv_i(const mxArray* wordsPtr, int** p_data, int* p_size)
{
    int p_flag[NUM_WORDS] = {FALSE};
    int ndocs = (int)mxGetNumberOfElements(wordsPtr);
    int i, j, count = 0;
    printf("* ndocs: %d\n",ndocs);
    for(i = 0; i < ndocs; ++i)
    {
        int*            wordset;
        int             nwords, x;
        const mxArray*  w_ptr = mxGetCell(wordsPtr, i);
        
        wordset = (int*)mxGetData(w_ptr);
        nwords  = (int)mxGetNumberOfElements(w_ptr);
        
        for(j = 0; j < nwords; ++j)
        {
            int x = wordset[j] - 1;
            if (p_flag[x] == FALSE)
            {
                p_data[x] = (int*)malloc(sizeof(int)*MAX_COUNT);
                p_flag[x] = TRUE;
                count++;
            }
            if (p_flag[x] == TRUE)
            {
                int n = p_size[x];
                if (isMem(i, p_data[x], n) == -1)   // if ith document already in current word data
                {
                    p_data[x][n]    = i;            // document id
                    p_size[x]       += 1;       // increase size of current word
                }
            }
        }
     } 
    return ndocs;
    //printf("* done load and fill data: %dwords!\n",count);
}