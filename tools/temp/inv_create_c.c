
#include "mex.h"

#include "inv_file.h"

#define dataIn      prhs[0]   
#define NUM_WORDS   1000000


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    int*     wset       = mxGetPr(prhs[1]);
    int*     wcount     = mxGetPr(prhs[2]);

    size_t  num_img     = 0;
    size_t  num_w       = mxGetNumberOfElements(prhs[1]);
//     
    int i = 0,
        j = 0;
    
    mxArray* ret;
    invFile* invFileOut;

    int    p_flag[NUM_WORDS]   = {0};
    int*    p[NUM_WORDS]        = {NULL};
    int     p_i[NUM_WORDS]      = {0};
    
  
    if (mxIsCell(dataIn) && (num_img = mxGetNumberOfElements(dataIn)) > 0)
    {
        //printf("numImg: %d\nnumW:  %d\n",num_img,num_w);
    }
    else return;
// 
   
    //for(i = 0; i < NUM_WORDS; ++i)
    //    p[i] = NULL;
    
    for (i = 0; i < num_w; i++)
    {
        int id = wset[i] - 1;
        int x = wcount[i];
        p[id] = (int*)malloc(sizeof(int)*x);
        p_flag[id] = 1;
        //printf("w-c: %d-%d\n", id, x);
    }
    //p_i[0] = 0;
    //printf("done allocate!\n");

    //num_img = 1; // test
    for(i = 0; i < num_img; ++i)
    {
        int* w;
        int n, x;
        const mxArray* w_ele_ptr = mxGetCell(dataIn, i);
        w = (int*)mxGetData(w_ele_ptr);
        n = mxGetNumberOfElements(w_ele_ptr);
        //printf("[%d] %d\n",i,n);
       for(j = 0; j < n; ++j)
       {
            int x = w[j] - 1;
            if (p_flag[x] == 1)
            {
                int p_i_len = p_i[x];
                //if(p_i_len >50) printf("p_i: %d [%d - %d - %d]\n", p_i_len, x, i, j);
                //printf("%d-%d-%d\n",x,p_i[x],p_i[0]);
                if (isMem(i, p[x], p_i_len) == -1)
                {
                    p[x][p_i_len] = i;
                    p_i[x] = p_i_len + 1;
                }   
            }
       }
     }
    //printf("done load and fill data!\n");
    
    invFileOut = (invFile*)malloc(sizeof(invFile));
    
    invFileOut->num_words   = NUM_WORDS;
    invFileOut->inv_file    = p;
    invFileOut->size_pw     = p_i;
    invFileOut->flag        = p_flag;
    //     
     ret = mxCreateNumericMatrix(1,1,mxINDEX_CLASS,mxREAL);
     *(invFile**) mxGetPr(ret) = invFileOut;
     plhs[0] = ret;

}



