function [S] = cpulse(Is,Ts,Td,Ip,Tp)
%PULSE Creates a pulse
%   [S] = cpulse(Is,Ts,Td,Ip,Tp) this function creates a conditioned stimulation pulse.
%   The condition pulse has an intensity [Ip] and duration [Tp] and the stimulation pulse
%   is located at a delay of [Td] after the onset of the conditioned pulse. The stimulation
%   pulse has an intensity [Is] and duration [Ts].
S = [2 Is Ts Ip Tp Td 0];
