function [P] = parameters(t0,t1,h,Fs,EarlyStop,save)
%PARAMETERS Creates the parameters for the simpatch funtion
%  [P] = parameters(t0,t1,h,Fs,EarlyStop,save)
P = [t0 t1 h Fs EarlyStop save];