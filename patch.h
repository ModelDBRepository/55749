#ifndef PATCH_HEADER_V10
#define PATCH_HEADER_V10

#define RECT				0
#define RAMP				1
#define CPULSE			2
#define PRECT				3
#define EXPR				4
#define FPRECT1			5 //Fixed intensity prepulse I
#define FPRECT2			6 //Fixed intensity prepulse II

#define IDLE				0
#define DETECTED		1

typedef struct Ion_n {
	double iNaf;
	double iNap;
	double iKf;
	double iKs;
} TIon_n;

typedef struct Ion_i {
	double iNaf;
	double iKs;
	double iL;
} TIon_i;

typedef struct Conductance {
	double gNaf;
	double gNap;
	double gKf;
	double gKs;
	double gL;
	double eL;
} TConductance;

typedef struct Kinetics_n {
	double m;
	double h;
	double p;
	double n;
	double s;
} TKinetics_n;

typedef struct Kinetics_i {
	double m;
	double h;
	double s;
} TKinetics_i;

typedef struct Rate {
  double A;
	double B;
	double C;
} TRate;

typedef struct Kinetics {
	TRate am; TRate bm;
	TRate ah; TRate bh;
	TRate ap; TRate bp;
	TRate an; TRate bn;
	TRate as; TRate bs;
} TKinetics;

typedef struct Geometry {
	double D;
	double dn;
	double di;
	double l;
	double L;
} TGeometry;

typedef struct Model {
	double Cn;
	double Ci;
	double Cm;
	double Ril;
	double eNa;
	double eK;

	TKinetics kin;
	TConductance gNode;
	TConductance gInter;

	//Initial conditions
	TKinetics_n Knode0;
	TKinetics_i Kinter0;
	double E0;
	double Ei0;
} TModel;

typedef struct Stimulus {
	int type;
	double Is;
	double Ts;
	double Ip;
	double Tp;
	double Tisi;
	double Idc;
} TStimulus;

typedef struct Parameter {
	double t0;
	double t1;
	double h;
	int		 Fs;

	int		 EarlyStop;
	int		 save;
} TParameter;

#endif 

