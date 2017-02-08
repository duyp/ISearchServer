
int isMem(int, int*, int);

typedef struct {
    int num_docs;   // number of documents
    int num_words;  // size of dictionary
    int* size_pw;   // number of images per words
    int** inv_file; // inverted index
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

double getInvSize(const invFile* inv)
{
    double sum = 0;
    int i,j;
    sum += sizeof(inv->num_words) + inv->num_words*sizeof(int*)*2;
    for(i = 0; i < inv->num_words; i++)
    {
        sum += sizeof(int)* inv->size_pw[i];
    }
    return sum;
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