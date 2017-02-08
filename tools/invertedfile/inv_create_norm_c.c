
#include "mex.h"
#include "inv_file_norm.h"

#define dataIn      prhs[0]
#define NUM_WORDS   1000000
#define MAX_COUNT   100

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    int         ndocs;         // number of input documents
    mxArray*    out;           // output pointer
    invFile*    invFileOut;    // outpute inverted file index
    int         p_flag[NUM_WORDS]   = {0};      // invFile flags
    invNode*    p_data[NUM_WORDS]   = {NULL};   // invFile data
    int         p_i[NUM_WORDS]      = {0};
    int         i       = 0,
                j       = 0,
                count   = 0;
    
    // check input data type (dataIn must be a Cell)
    // get and check numbers of input documents
    if (mxIsCell(dataIn) && (ndocs = (int)mxGetNumberOfElements(dataIn)) > 0)
    {
        printf("numbers of input docs: %d\n",ndocs);
        // allocate output inverted file
        invFileOut = (invFile*)malloc(sizeof(invFile));
    }
    else return;

    //num_img = 1; // test
    for(i = 0; i < ndocs; ++i)
    {
        int*            w;              // list words of curent documents (ith)
        int             nw;              // number of words in this document
        const mxArray*  docPtr = mxGetCell(dataIn, i);  // pointer to document
        
        if (docPtr == NULL) continue;   // can't access this document data
        
        w = (int*)mxGetData(docPtr);    // get document data from pointer
        nw = (int)mxGetNumberOfElements(docPtr);
        
        for(j = 0; j < nw; ++j)
        {
            // jth word (current word)
            int x = w[j] - 1;
            // compute inverted index
            if (p_flag[x] == 0)         // if current word dose not exist in inverted file -> allocate
            {
                p_data[x] = (invNode*)malloc(sizeof(invNode)*MAX_COUNT);
                p_flag[x] = 1;          // update word existen in inverted file
                count++;                // count number of words
            }
            if (p_flag[x] == 1)         // if current word has been allocated
            {
                int nd = p_i[x];        // get current number of document at current word
                if (isNodeListMem(i, p_data[x], nd) != -1)   // if ith document already in current word data
                {
                   p_data[x][nd].val += (float)1/nw;           // increase normalize value
                }
                else
                {
                    p_data[x][nd].id    = i;            // document id
                    p_data[x][nd].val   = (float)1/nw;   // increase normalize value
                    p_i[x] += 1;       // increase size of current word
                }
            }
        }
    }
    // assign value to output
    invFileOut->num_docs    = ndocs;
    invFileOut->num_words   = NUM_WORDS;
    invFileOut->inv_file    = p_data;
    invFileOut->size_pw     = p_i;
    
    printf("done load and fill data to inverted file: %d words!\nInverted file size: %.0f\n",count, getInvSize(invFileOut));

    // fill data to output pointer
     out = mxCreateNumericMatrix(1,1,mxINDEX_CLASS,mxREAL);
     *(invFile**) mxGetPr(out) = invFileOut;
     plhs[0] = out;
     
}