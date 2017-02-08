#include "mex.h"
#include "inv_file.h"

#define MAX_COUNT   100
#define dataIn      prhs[0]
#define NUM_WORDS   1000000
#define TRUE        1
#define FALSE       0

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    mxArray*    out;
    invFile*    invFileOut;
    char        p_flag[NUM_WORDS]   = {FALSE};
    int*        p_data[NUM_WORDS]   = {NULL};
    int         p_size[NUM_WORDS]   = {0};
    size_t      ndocs               = 0;
    int         i, j, count = 0;
    
    if (mxIsCell(dataIn) && (ndocs = mxGetNumberOfElements(dataIn)) > 0)
    {
        printf("ndocs: %d\n",ndocs);
    }
    else return;

    for(i = 0; i < ndocs; ++i)
    {
        int* w;
        int n, x;
        const mxArray* w_ele_ptr = mxGetCell(dataIn, i);
        w = (int*)mxGetData(w_ele_ptr);
        n = mxGetNumberOfElements(w_ele_ptr);
        
        for(j = 0; j < n; ++j)
        {
            int x = w[j] - 1;
            if (p_flag[x] == FALSE)
            {
                //printf("Allocating...words[%d]\n",x);
                p_data[x] = (int*)malloc(sizeof(int)*MAX_COUNT);
                p_flag[x] = TRUE;
                count++;
            }
            if (p_flag[x] == TRUE)
            {
                int p_i_len = p_size[x];
                if (isMem(i, p_data[x], p_i_len) == -1)
                {
                    p_data[x][p_i_len] = i;
                    p_size[x] = p_i_len + 1;
                }   
            }
        }
     }
    printf("done load and fill data: %d words!\n",count);
    
    invFileOut = (invFile*)malloc(sizeof(invFile));
    
    invFileOut->num_words   = NUM_WORDS;
    invFileOut->num_docs    = ndocs;
    invFileOut->inv_file    = p_data;
    invFileOut->size_pw     = p_size;
    
     out = mxCreateNumericMatrix(1,1,mxINDEX_CLASS,mxREAL);
     *(invFile**) mxGetPr(out) = invFileOut;
     plhs[0] = out;
     
     printf("total size of inverted file: %.0f\n", getInvSize(invFileOut));
}