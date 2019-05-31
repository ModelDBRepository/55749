#include "mex.h"
#include "mxUtility.h"

int isScalar(const mxArray *prhs) {
	if(!mxIsDouble(prhs) || mxIsComplex(prhs) || 
		!(mxGetM(prhs) == 1 && mxGetN(prhs) == 1)) {
		return 0;
	}
	return 1;
}

long isVector(const mxArray *prhs) {
	if(mxIsDouble(prhs) && !mxIsComplex(prhs) && 
		(mxGetM(prhs) == 1 || mxGetN(prhs) == 1)) {
		return mxGetM(prhs) == 1 ? mxGetN(prhs) : mxGetM(prhs);
	}
	return 0;
}

long idx(long i,long j,long M) {
  return i + j*M;
}