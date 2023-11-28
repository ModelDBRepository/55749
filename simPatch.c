#include "mex.h"
#include "mxUtility.h"
#include "patch.h"
#include <stdio.h>

//#define DEBUG_OUTPUT

#define NO_OF_INPUT_ARGS   8   //Change to the correct number of input arguments
#define NO_OF_OUTPUT_ARGS  1   //Change to the correct number of output arguments 
                               //(there is always one argument [ans].

/**********************************************************************
 *																																	  *
 *                            simPatch															  *
 *																																	  *
 * [ap] = simPatch(P,S,E,GN,GI,A,B) simulates a patch of a myelinated *
 * nerve fiber. Dependent on the parameters passed to the function    *
 * function will stop when it has detected a number of APs, and the   *
 * output may go to "data.out".                                       *
 *																																	  *
 **********************************************************************/


void mexFunction(int nlhs,mxArray *plhs[],
								 int nrhs,const mxArray *prhs[]) 
{
	//Parameters for the patch function
	TParameter par;
	TStimulus  s;
	TModel model;
	//Inputs 
	double *P;
	double *S;
	double *E;
	double *GN;
	double *GI;
	double *A;
	double *B;
	double *X0;
	//Outputs
	double *AP;
	//Utility variables
	int i,j;

	// Check for correct number of input arguments
	if(nrhs != NO_OF_INPUT_ARGS) mexErrMsgTxt("Incorrect number of input arguments [P,S,E,GN,GI,A,B X0]");

	// Check for the correct format of input arguments
	if(isVector(prhs[0]) != 6) mexErrMsgTxt("Incorrect number of parameters: P = [t0 t1 h Fs EarlyStop save]");
	if(isVector(prhs[1]) != 7) mexErrMsgTxt("Incorrect stimulus: S = [type Is Ts Ip Tp Tisi Idc]");
	if(isVector(prhs[2]) != 6) mexErrMsgTxt("Incorrect electrical specification: E = [Cn Ci Cm Ril eNa eK]");
	if(isVector(prhs[3]) != 4) mexErrMsgTxt("Incorrect nodal conductance: GN = [gNaf gNap gKf gKs]");
	if(isVector(prhs[4]) != 4) mexErrMsgTxt("Incorrect inter-nodal conductance: GI = [ gNaf gKs gL eL]");
	if((mxGetM(prhs[5]) != 5) && (mxGetN(prhs[5]) != 3)) mexErrMsgTxt("Incorrect rate A, has to be 5 x 3");
	if((mxGetM(prhs[6]) != 5) && (mxGetN(prhs[6]) != 3)) mexErrMsgTxt("Incorrect rate B, has to be 5 x 3");
	if(isVector(prhs[7]) != 10) mexErrMsgTxt("Incorrect initial conditions: X0 = [En Ei m_n h_n p_n n_n s_n m_i h_i s_i]");

	//Check the number of output arguments
	if(nlhs > NO_OF_OUTPUT_ARGS) mexErrMsgTxt("Incorrect number of output arguments.");
	
	//Create the model - from the input arguments
	//First extract the parameters
	P  = mxGetPr(prhs[0]); 	S = mxGetPr(prhs[1]); 	E = mxGetPr(prhs[2]);	GN = mxGetPr(prhs[3]);
	GI = mxGetPr(prhs[4]);	A = mxGetPr(prhs[5]);	  B = mxGetPr(prhs[6]); X0 = mxGetPr(prhs[7]);
	
	par.t0 = P[0]; par.t1 = P[1]; par.h = P[2]; 
	par.Fs = (int) P[3]; par.EarlyStop = (int) P[4]; par.save = (int) P[5];
	s.type = (int) S[0]; 
	s.Is   = S[1]; s.Ts  = S[2]; 
	s.Ip   = S[3]; s.Tp  = S[4]; 
	s.Tisi   = S[5]; s.Idc = S[6];

	model.Cn  = E[0]; model.Ci  = E[1];	model.Cm = E[2]; model.Ril = E[3];
	model.eNa = E[4];	model.eK  = E[5];	

	model.gNode.gNaf = GN[0];	model.gNode.gNap = GN[1];
	model.gNode.gKf  = GN[2];	model.gNode.gKs  = GN[3];

	model.gInter.gNaf = GI[0]; model.gInter.gKs = GI[1];
	model.gInter.gL   = GI[2]; model.gInter.eL  = GI[3];

	model.kin.am.A = A[idx(0,0,5)]; model.kin.am.B = A[idx(0,1,5)]; model.kin.am.C = A[idx(0,2,5)];
	model.kin.ah.A = A[idx(1,0,5)]; model.kin.ah.B = A[idx(1,1,5)]; model.kin.ah.C = A[idx(1,2,5)];
	model.kin.ap.A = A[idx(2,0,5)]; model.kin.ap.B = A[idx(2,1,5)]; model.kin.ap.C = A[idx(2,2,5)];
	model.kin.an.A = A[idx(3,0,5)]; model.kin.an.B = A[idx(3,1,5)]; model.kin.an.C = A[idx(3,2,5)];
	model.kin.as.A = A[idx(4,0,5)]; model.kin.as.B = A[idx(4,1,5)]; model.kin.as.C = A[idx(4,2,5)];

	model.kin.bm.A = B[idx(0,0,5)]; model.kin.bm.B = B[idx(0,1,5)]; model.kin.bm.C = B[idx(0,2,5)];
	model.kin.bh.A = B[idx(1,0,5)]; model.kin.bh.B = B[idx(1,1,5)]; model.kin.bh.C = B[idx(1,2,5)];
	model.kin.bp.A = B[idx(2,0,5)]; model.kin.bp.B = B[idx(2,1,5)]; model.kin.bp.C = B[idx(2,2,5)];
	model.kin.bn.A = B[idx(3,0,5)]; model.kin.bn.B = B[idx(3,1,5)]; model.kin.bn.C = B[idx(3,2,5)];
	model.kin.bs.A = B[idx(4,0,5)]; model.kin.bs.B = B[idx(4,1,5)]; model.kin.bs.C = B[idx(4,2,5)];

	model.E0 = X0[0]; model.Ei0 = X0[1]; 
	model.Knode0.m = X0[2]; model.Knode0.h = X0[3]; 
	model.Knode0.p = X0[4];	model.Knode0.n = X0[5]; 
	model.Knode0.s = X0[6];
	
	model.Kinter0.m = X0[7]; model.Kinter0.h = X0[8]; 
	model.Kinter0.s = X0[9];

	//create output arguments,this is done with mxCreateDoubleMatrix
	AP = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL));
	//*AP = 0;
	*AP = simPatch(model,s,par);

}
