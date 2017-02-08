/* 
 * File:   cal_v2v_dis_L2.c
 * Author: biendltb
 *
 * Created on April 24, 2014, 11:50 PM
 *
 *
 * Calculate the distance between 2 vector
 * 
 * The calling syntax is:
 *
 *		
 *
 * This is a MEX-file for MATLAB.
*/


#include <math.h>
#include "mex.h"
#include "matrix.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    /* declare variables */
    
     
    double *v1_val, *v2_val, *v1_id, *v2_id;
    
    double *dis = 0,
        sum_sqr = 0;
    
    double v1_n, v2_n;
            
    int64_T    i = 0, j = 0;

    /* check number of input and output arguments */

    if (nrhs != 4) {

        mexErrMsgTxt("Wrong number of input arguments.");

    } else if (nlhs > 1) {

        mexErrMsgTxt("Too many output arguments.");

    }

    /* get input arguments */
    
    if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0])) {

        mexErrMsgTxt("x1 must be a int64 matrix.");

    }
    
    v1_id = (double *)mxGetData(prhs[0]);

    if (!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1])) {

        mexErrMsgTxt("x2 must be a double matrix.");

    }
    
    v1_val = mxGetPr(prhs[1]);    
    v1_n = mxGetNumberOfElements(prhs[1]);
    

    if (!mxIsDouble(prhs[2]) || mxIsComplex(prhs[2])) {

        mexErrMsgTxt("x3 must be a double matrix.");

    }
    
    v2_id = (double *)mxGetData(prhs[2]);

    if (!mxIsDouble(prhs[3]) || mxIsComplex(prhs[3])) {

        mexErrMsgTxt("x4 must be a double matrix.");

    }
    
    v2_val = mxGetPr(prhs[3]);
    v2_n = mxGetNumberOfElements(prhs[3]);
    
    /* allocate and initialise output matrix */

   plhs[0] = mxCreateDoubleScalar(0);

   dis = mxGetPr(plhs[0]);
   
   /* Calculate */
    while (i < v1_n && j < v2_n){
        if(v1_id[i] == v2_id[j]) {
            double dist = v1_val[i] - v2_val[j];
            sum_sqr += dist > 0 ? dist : -dist;
            i++; j++;
        } else if (v1_id[i] < v2_id[j]) {
            sum_sqr += v1_val[i];
            i++;
        } else {
            sum_sqr += v2_val[j];
            j++;
        }
        
    }
    //Calculate the rest of array
    while(i < v1_n) {
        sum_sqr += v1_val[i];
        i++;
    }
    while (j < v2_n){
        sum_sqr += v2_val[j];
        j++;
    }
    *dis = sum_sqr;
}