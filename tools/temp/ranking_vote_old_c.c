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

#include "inv_file.h"

#define MAX_COUNT 1000

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    const invFile* inv = *(invFile**) mxGetData(prhs[0]);
    int* q_words = mxGetPr(prhs[1]);
//     
    int num_q_words = mxGetNumberOfElements(prhs[1]);
    //printf("%d\n",num_q_words);
//     
    int sum = 0;
    int* count = (int*)malloc(sizeof(int)*num_q_words);
    int** matrix_cand = (int**)malloc(sizeof(int*)*num_q_words);
    
    mwSize dims[2];
    int *list_cand, *count_cand, *count_cand_tmp, *pOutId, *pOutVal;
    int sum_vote = 0;
    double* num_vote = 0;
    int num_cand = 0;
    
    int i = 0, 
        j = 0;
    
    for (i = 0; i < num_q_words; i++)
    {
        int w = q_words[i] - 1;
        if(inv->flag[w] == 1)
        {
            int* list_im_id = inv->inv_file[w];
            matrix_cand[i] = list_im_id;
            count[i] = inv->size_pw[w];
            sum += count[i];
        }
    }
    
    // list candidate return
    list_cand = (int*)malloc(sizeof(int)*sum);
    count_cand = (int*)malloc(sizeof(int)*sum);
    
    //printf("num_qw: %d\n", num_q_words);
    for(i=0; i < num_q_words; i++)
    {   
        if (inv->flag[q_words[i] - 1] == 1)
        {
            //printf("%d \n",i);
            for(j=0; j < count[i]; j++)
            {
                int x = matrix_cand[i][j] + 1;
                int pos = isMem(x, list_cand, num_cand);
                if(pos == -1)
                {
                     list_cand[num_cand] = x;
                     count_cand[num_cand] = 1;
                     num_cand++;                        
                } else 
                {
                    count_cand[pos]++;
                }
            }
        }
    }
    
    dims[0] = 1;
    dims[1] = num_cand;
    
    plhs[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutId = (int*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
    pOutVal = (int*)mxGetData(plhs[1]);
    
    quicksort(list_cand, count_cand, 0, num_cand-1);
// //    
   for(i = 0; i < num_cand; i++)
   {
       pOutId[i] = list_cand[i];
       pOutVal[i] = count_cand[i];
   }
}