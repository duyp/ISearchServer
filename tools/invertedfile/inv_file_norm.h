
typedef struct {
    int id;         // id of document (image)
    float val;     // normalize value
} invNode;

typedef struct {
    int* words;
    int size;
} document;

typedef struct {
    int num_docs;   // number of documents
    int num_words;  // size of dictionary
    int* size_pw;   // number of images per words
    invNode** inv_file; // inverted index
} invFile;

/*
 * Check whether list contain a specific element
 * If it contains, return position of the element
 * If not, return -1
 */
int isMem( int x, int* v, int n)
{
    int i;
    for(i = 0; i < n; ++i)
        if(x==v[i])
            return i;
    return -1;
}

/*
 * Check whether list contain a specific element
 * If it contains, return position of the element
 * If not, return -1
 */
int isNodeListMem( int x, const invNode* v, int n)
{
    int i;
    for(i = 0; i < n; ++i)
        if(x==v[i].id)
            return i;
    return -1;
}

double getInvSize(const invFile* inv)
{
    double sum = 0;
    int i;
    sum += sizeof(inv->num_words) + inv->num_words*sizeof(int*)*2;
    for(i = 0; i < inv->num_words; i++)
    {
        if (inv->size_pw[i] > 0)
            sum += sizeof(invNode)*inv->size_pw[i];
    }
    return sum;
}

void hist(float** out, const int* doc, int docSize, int num_words)
{
    int i;
    out[0] = (float*)malloc(sizeof(float)*num_words);
    
    for(i = 0; i < num_words; i++)
        out[0][i] = 0.0f;
    
    for(i = 0; i < docSize; i++)
    {
        out[0][doc[i]-1] += (float)1/docSize;
    }
}

void hist_compress(invNode** out, int* nout, const int* doc, int nwords, int num_words)
{
    float* temp = (float*)malloc(sizeof(float)*num_words);
    int i, pos;
    
    // initialize
    for(i = 0;i < num_words; i++)
        temp[i] = 0;
    
    // calculate normalize value
    for (i = 0; i < nwords; i++)
        temp[doc[i]-1] += (float)1/nwords;
    
    // counting
	nout[0] = 0;
    for (i = 0; i < num_words; i++)
		if (temp[i]>0) nout[0]++;
    
    // allocating output
	out[0] = (invNode*)malloc(sizeof(invNode)*(nout[0]));
    
    // filtering output
    pos = 0;
    for(i = 0; i < num_words; i++)
    {
        if (temp[i] > 0)
        {
            out[0][pos].id = i;
            out[0][pos].val = temp[i];
            //printf("id = %d     val = %f\n",i,temp[i]);
            pos ++;
        }
    }
}

/**
 *
 *
 *
 */
void quicksort(int* id,int* val, int first,int last)
{
    int pivot,j,temp,i, temp_i;

     if(first<last){
         pivot=first;
         i=first;
         j=last;

         while(i<j){
             while(val[i]>=val[pivot]&&i<last)
                 i++;
             while(val[j]<val[pivot])
                 j--;
             if(i<j){
                 temp=val[i];
                  val[i]=val[j];
                  val[j]=temp;

				  temp_i = id[i];
				  id[i] = id[j];
				  id[j] = temp_i;
             }
         }

         temp=val[pivot];
         val[pivot]=val[j];
         val[j]=temp;

		 temp_i = id[pivot];
		 id[pivot] = id[j];
		 id[j] = temp_i;

         quicksort(id, val,first,j-1);
         quicksort(id, val,j+1,last);

    }
}

void quicksortf(int* id,float* val, int first,int last)
{
    int     pivot,j,i;
    int     temp_i;
    float   temp;
    
     if(first<last){
         pivot=first;
         i=first;
         j=last;

         while(i<j){
             while(val[i]>=val[pivot]&&i<last)
                 i++;
             while(val[j]<val[pivot])
                 j--;
             if(i<j){
                 temp=val[i];
                  val[i]=val[j];
                  val[j]=temp;

				  temp_i = id[i];
				  id[i] = id[j];
				  id[j] = temp_i;
             }
         }

         temp       = val[pivot];
         val[pivot] = val[j];
         val[j]     = temp;

		 temp_i     = id[pivot];
		 id[pivot]  = id[j];
		 id[j]      = temp_i;

         quicksortf(id, val,first,j-1);
         quicksortf(id, val,j+1,last);

    }
}

void quicksortf_dist(int* id,float* val, int first,int last)
{
    int     pivot,j,i;
    int     temp_i;
    float   temp;
    
     if(first<last){
         pivot=first;
         i=first;
         j=last;

         while(i<j){
             while(val[i]<=val[pivot]&&i<last)
                 i++;
             while(val[j]>val[pivot])
                 j--;
             if(i<j){
                 temp=val[i];
                  val[i]=val[j];
                  val[j]=temp;

				  temp_i = id[i];
				  id[i] = id[j];
				  id[j] = temp_i;
             }
         }

         temp       = val[pivot];
         val[pivot] = val[j];
         val[j]     = temp;

		 temp_i     = id[pivot];
		 id[pivot]  = id[j];
		 id[j]      = temp_i;

         quicksortf(id, val,first,j-1);
         quicksortf(id, val,j+1,last);

    }
}