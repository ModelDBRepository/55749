function [AP,APs] = isAP(Is,noAP,tspan,M,S)
%isAP Is the stimulus resulting in an action potential
%   [AP,APs] = isAP(Is,noAP,tspan,M,S) this function determines
%   whether or not a nerve fiber respond to a stimulus with one
%   or more APs. The stimulus intensity is given as Is, and the 
%   number of APs that should be present is given as [noAP]. The
%   function return 1 if there is [noAP] present, 0 if there is 
%   less. To pass [noAP] equal or less than zero is an error
%   and the function will respond unpredictable, though it will 
%   reformat your harddrive as a punishment :o)
%
%   The number of APs counted is returned in [APs]. Note that the
%   function returns when it has counted [noAP] APs, so the actual
%   no of APs may be greater than [noAP]. If you wish to qount the 
%   number of APs, set [noAP] to an impropable high number (e.g. one
%   trillion) and sit down and wait for the function to take its 
%   natural course to the end of tspan. [tspan] defines the time 
%   interval, the function will integrate the nerve model from time
%   tspan(1) to tspan(2). [M] and [S] is the model and stimulus,
%   respectively.
%
%Please enjoy, 
%   Kristian Hennings
h = 0.5e-6;
P = parameters(tspan(1),tspan(2),h,1e6,noAP,0);
S(2) = Is;
APs = simPatch(P,S,M.E,M.GN,M.GI,M.A,M.B,M.X0);
if APs == noAP
    AP = 1;
else 
    AP = 0;
end

