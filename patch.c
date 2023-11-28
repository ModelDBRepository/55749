#include <stdio.h>
#include "patch.h"
#include <math.h>

//#define DEBUG_OUTPUT

/**************************************************************
 *
 *											  Constants 
 *
 **************************************************************/

const double R = 8.3144;
const double F = 96485;

/**************************************************************
 *
 *                   Diagnostic Functions
 *
 **************************************************************/

#ifdef DEBUG_OUTPUT

void debugDump(TParameter p,TStimulus s,TModel m) {
	FILE *file;
	if((file = fopen("debug.txt","wt")) != NULL) {
		fprintf(file,"PATAMETERS:\n");
		fprintf(file,"INTEGRATION: TSPAN = [%.1fms %.1fms], h = %.1fus, ES = %d\n",p.t0*1e3,p.t1*1e3,p.h*1e6,p.EarlyStop);
		fprintf(file,"SAVE       : SAVE = %d, Fs = %d\n\n",p.save,p.Fs);

		fprintf(file,"MODEL:\n");
		fprintf(file,"ELECTRICAL: [Cn = %.2fpF Ci = %.2fpF Cm = %.2fpF Ril = %.1fMohm eNa = %.2fmV eK = %.2fmV\n",
			m.Cn*1e12,m.Ci*1e12,m.Cm*1e12,m.Ril*1e-6,m.eNa*1e3,m.eK*1e3);
		fprintf(file,"NODAL CONDUCTANCE     : gNaf = %.2fnS, gNap = %.2fnS, gKf = %.2fnS, gKs = %.2fnS\n",
			m.gNode.gNaf*1e9,m.gNode.gNap*1e9,m.gNode.gKf*1e9,m.gNode.gKs*1e9);
		fprintf(file,"INTER-NODAL CONDUCTACE: gNaf = %.2fnS gKs = %.2fnS gL = %.2fnS eL = %.2fmV\n",
			m.gInter.gNaf*1e9,m.gInter.gKs*1e9,m.gInter.gL*1e9,m.gInter.eL*1e3);
		
		fprintf(file,"RATE A\n");
		fprintf(file,"am : %10.2f  %10.2f %10.2f\n",m.kin.am.A,m.kin.am.B,m.kin.am.C);
		fprintf(file,"ah : %10.2f  %10.2f %10.2f\n",m.kin.ah.A,m.kin.ah.B,m.kin.ah.C);
		fprintf(file,"ap : %10.2f  %10.2f %10.2f\n",m.kin.ap.A,m.kin.ap.B,m.kin.ap.C);
		fprintf(file,"an : %10.2f  %10.2f %10.2f\n",m.kin.an.A,m.kin.an.B,m.kin.an.C);
		fprintf(file,"as : %10.2f  %10.2f %10.2f\n",m.kin.as.A,m.kin.as.B,m.kin.as.C);
		
		fprintf(file,"RATE B\n");
		fprintf(file,"bm : %10.2f  %10.2f %10.2f\n",m.kin.bm.A,m.kin.bm.B,m.kin.bm.C);
		fprintf(file,"bh : %10.2f  %10.2f %10.2f\n",m.kin.bh.A,m.kin.bh.B,m.kin.bh.C);
		fprintf(file,"bp : %10.2f  %10.2f %10.2f\n",m.kin.bp.A,m.kin.bp.B,m.kin.bp.C);
		fprintf(file,"bn : %10.2f  %10.2f %10.2f\n",m.kin.bn.A,m.kin.bn.B,m.kin.bn.C);
		fprintf(file,"bs : %10.2f  %10.2f %10.2f\n",m.kin.bs.A,m.kin.bs.B,m.kin.bs.C);
		
		fprintf(file,"INITIAL CONDITIONS:\n");
		fprintf(file,"POTENTIALS  : En = %.2fmV Ei = %.2fmV\n",m.E0*1e3,m.Ei0*1e3);
		fprintf(file,"NODAL       : m = %.4f h = %.4f p = %.4f n = %.4f s = %.4f\n",
			m.Knode0.m,m.Knode0.h,m.Knode0.p,m.Knode0.n,m.Knode0.s);
		fprintf(file,"INTER-NODAL : m = %.4f h = %.4f s = %.4f\n",m.Kinter0.m,m.Kinter0.h,m.Kinter0.s);

		fprintf(file,"STIMULUS: \n");
		fprintf(file,"RAW DATA : %d %e %e %e %e %e\n",s.type,s.Is,s.Ts,s.Ip,s.Ip,s.Tisi);
		fprintf(file,"STIMULUS : ");
		switch(s.type) {
		case RECT   : fprintf(file,"PULSE Is = %.2fnA Ts = %.2fms\n",s.Is*1e9,s.Ts*1e3); break;
		case RAMP   : fprintf(file,"RAMP  Is = %.2fnA Ts = %.2fms\n",s.Is*1e9,s.Ts*1e3); break;
		case CPULSE : fprintf(file,"C-PULSE Ic = %.2fnA Tc = %.2fms\n Tisi = %.2fms Is = %.2fnA Ts = %.2fms\n",
										s.Ip*1e9,s.Tp*1e3,s.Tisi*1e3,s.Is*1e9,s.Ts*1e3); break;
		case PRECT  : fprintf(file,"R-PREPULSE Ip = %.2fnA Tp = %.2fms\n Tisi = %.2fms Is = %.2fnA Ts = %.2fms\n",
										s.Ip*1e9,s.Tp*1e3,s.Tisi*1e3,s.Is*1e9,s.Ts*1e3); break;
		}

		fclose(file);
	} 
}

#endif

/**************************************************************
 *
 *                     Stimuli Functions
 *
 **************************************************************/

double stimulus(double t,TStimulus s) {
	switch(s.type) {
		case RECT      : 
			if(t < 0) 					return 0 + s.Idc;
			else if(t <= s.Ts)	return s.Is + s.Idc;
			else								return 0 + s.Idc;
		case RAMP      :
			if(t < 0)						return 0 + s.Idc;
			else if(t <= s.Ts)	return s.Is*(t/s.Ts) + s.Idc;
			else								return 0 + s.Idc;
		case CPULSE    : {
			double ic;
			double is;
			if(t < 0) 								ic = 0;
			else if(t <= s.Tp)				ic = s.Ip;
			else											ic = 0;
			if(t-s.Tisi < 0) 					is = 0;
			else if(t-s.Tisi <= s.Ts)	is = s.Is;
			else											is = 0;
			return is+ic+s.Idc;
										 } break;
		case PRECT     : {
			if(t < 0)								return 0 + s.Idc;
			else if(t <= s.Tp)			return s.Ip + s.Idc;
			else if(t-s.Tp <= s.Ts)	return s.Is + s.Idc;
			else										return 0 + s.Idc;
										 } break;
		case EXPR			 : {
			if(t < 0)								return 0 + s.Idc;
			else										return s.Is*(1-exp(-(t/s.Ts))) + s.Idc;
										 } break;
		case FPRECT1    : {
			if(t < 0)               return 0;
			else if(t <= s.Ts*s.Tp)      return s.Ip*s.Is;
			else if((s.Ts*s.Tp < t) && (t <= s.Ts)) return s.Is;
			else                    return 0;
										 } break;
		case FPRECT2    : {
			if(t < 0)               return 0;
			else if(t <= s.Tp)      return s.Ip*s.Is;
			else if((s.Tp < t) && (t <= s.Ts+s.Tp)) return s.Is;
			else                    return 0;
										 } break;
		default				 : return 0;
	}
}

/**************************************************************
 *
 *                      Core Functions
 *
 **************************************************************/

double rate1(double E,TRate r) { return 1e3*r.A*(E-r.B)/(1-exp((r.B-E)/r.C)); }
double rate2(double E,TRate r) { return 1e3*r.A*(r.B-E)/(1-exp((E-r.B)/r.C)); }
double rate3(double E,TRate r) { return 1e3*r.A/(1+exp((r.B-E)/r.C)); }

double dmdt(double m,double E,TKinetics k) { return rate1(E,k.am)*(1-m)-rate2(E,k.bm)*m; }
double dhdt(double h,double E,TKinetics k) { return rate2(E,k.ah)*(1-h)-rate3(E,k.bh)*h; }
double dpdt(double p,double E,TKinetics k) { return rate1(E,k.ap)*(1-p)-rate2(E,k.bp)*p; }
double dndt(double n,double E,TKinetics k) { return rate1(E,k.an)*(1-n)-rate2(E,k.bn)*n; }
double dsdt(double s,double E,TKinetics k) { return rate1(E,k.as)*(1-s)-rate2(E,k.bs)*s; }

TIon_i Iion_i(double Ei,TKinetics_i k,TModel model) {
	TIon_i i;
	i.iNaf  = model.gInter.gNaf*k.m*k.m*k.m*k.h*(Ei-model.eNa);
	i.iKs   = model.gInter.gKs*k.s*(Ei-model.eK);
	i.iL    = model.gInter.gL*(Ei-model.gInter.eL);
	return i;
}

TIon_n Iion_n(double En,TKinetics_n k,TModel model) {
	TIon_n i;
	i.iNaf  = model.gNode.gNaf*k.m*k.m*k.m*k.h*(En-model.eNa);
	i.iNap  = model.gNode.gNap*k.p*k.p*k.p*(En-model.eNa);
	i.iKf   = model.gNode.gKf*k.n*k.n*k.n*k.n*(En-model.eK);
	i.iKs   = model.gNode.gKs*k.s*(En-model.eK);
	return i;
}

void prnResult(FILE *file,
							 double t,double Istim,double En,double Ei,
							 TKinetics_n kNode,TKinetics_i kInter,
							 TIon_n In,TIon_i Ii) {
	fprintf(file,"%.3e  %.3e %.2e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e %.3e\n",
						   t*1e3,En*1e3,Ei*1e3,Istim*1e9,
							 kNode.m,kNode.h,kNode.p,kNode.n,kNode.s,		
							 kInter.m,kInter.h,kInter.s,
							 In.iNaf*1e9,In.iNap*1e9,In.iKf*1e9,In.iKs*1e9,
							 Ii.iNaf*1e9,Ii.iKs*1e9,Ii.iL*1e9);
}

void prnX0(double En,double Ei,TKinetics_n kNode,TKinetics_i kInter) {
	FILE *file;
	if((file = fopen("x0.out","wt")) != NULL) {
		fprintf(file,"%e %e %e %e %e %e %e %e %e %e",
			En,Ei,kNode.m,kNode.h,kNode.p,kNode.n,kNode.s,kInter.m,kInter.h,kInter.s);
		fclose(file);
	}
}
int simPatch(TModel m,TStimulus s,TParameter p) {
	TIon_i Ii;
	TIon_n In;
	double Istim;
	TKinetics_i kInter = m.Kinter0;
	TKinetics_n kNode  = m.Knode0; 
	double En0;
	double Ei0;
	double En1 = m.E0;
	double Ei1 = m.Ei0;
	double dEn;

	double t = p.t0;
	int		 step = p.Fs;
	int		 stop = 0;
	int		 ap   = 0;
	int    state = IDLE;
	double tAP  = -1;

	FILE   *file;

#ifdef DEBUG_OUTPUT
	debugDump(p,s,m);
#endif
	if(p.save) file = fopen("data.out","wt");
	else file = NULL;

	while((t <= p.t1) && !stop) {
		Istim = stimulus(t,s);
		Ii = Iion_i(Ei1,kInter,m); 
		In = Iion_n(En1,kNode,m); 
		dEn = -(In.iKf+In.iKs+In.iNaf+In.iNap+Istim - (Ei1 - En1)/m.Ril)/(m.Cn + m.Cm);
		En0 = En1+p.h*dEn;
		Ei0 = Ei1-p.h*(Ii.iKs+Ii.iL+Ii.iNaf + (Ei1 - En1)/m.Ril - m.Cm*dEn)/m.Ci;
		kInter.m = kInter.m + p.h*dmdt(kInter.m,Ei1*1e3,m.kin);
		kInter.h = kInter.h + p.h*dhdt(kInter.h,Ei1*1e3,m.kin);
		kInter.s = kInter.s + p.h*dsdt(kInter.s,Ei1*1e3,m.kin);
		kNode.m = kNode.m + p.h*dmdt(kNode.m,En1*1e3,m.kin);
		kNode.h = kNode.h + p.h*dhdt(kNode.h,En1*1e3,m.kin);
		kNode.p = kNode.p + p.h*dpdt(kNode.p,En1*1e3,m.kin);
		kNode.n = kNode.n + p.h*dndt(kNode.n,En1*1e3,m.kin);
		kNode.s = kNode.s + p.h*dsdt(kNode.s,En1*1e3,m.kin);

		if((step == p.Fs) && (file != NULL) && p.save) {
			prnResult(file,t,Istim,En1,Ei1,kNode,kInter,In,Ii);
			step = 1;		
		}

		//Update before next step
		En1 = En0; Ei1 = Ei0; step++; t = t + p.h;
		
		//Detect action potential
		if(state == IDLE) {
			if(En1 > -30e-3) {
				state = DETECTED;
				ap++;
				if(p.EarlyStop == ap) stop = 1;
			}		
		} else {
			if(En1 < -30e-3) {
				state = IDLE;
			}
		}		
	}

	if((file != NULL) && p.save) {
		prnResult(file,t,Istim,En1,Ei1,kNode,kInter,In,Ii);
	}
	if(p.save)
		prnX0(En1,Ei1,kNode,kInter);

	if(file != NULL) fclose(file);
	return ap;
}