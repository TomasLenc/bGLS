%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function creats a stimulus that is similar to phase experiment (see
% Repp 2005)
% the phase alternates between positive and neagtive shift systematically
% this is actually a simplistic version of this stimulus
% usually replaced by a more sophisticated version
%
% output:
% OS(t) is the stimulus onset
% S(t) is the inter-stimulus interval
%
%note that S is unconventional since S(t)=OS(t)-OS(t-1) 
% and not like Vorberg and Schultze 2002 where C(t)=OS(t+1)-OS(t) 
%
% input:
% T0 is the inter onset interval
% phase shifts are of +/- dt
% rangeJump is a vector of the form [n1,n2] and this is range of beats 
% before next alteration of tempo.
% Nbeats is the total number of beats
%
% Written by Nori Jacoby, for help please contact: nori.viola@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==========================================================================
% ===== For information please contact: Nori Jacoby 
% ===== Nori.viola@gmail.com
% =====
% ===== If you are using the code,
% ===== Please cite this version:
% ===== 
% ===== Jacoby, Nori, Peter Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby. 
% ===== "Parameter Estimation of Linear Sensorimotor Synchronization Models: Phase Correction, Period Correction and Ensemble Synchronization." 
% ===== Special issue of Timing & Time Perception (RPPW).
% ==========================================================================

function [S,OS]=create_PhaseSequence(Nbeats,T0,dt,rangeJump)

% compute the two inter-onset intervals
T1=T0-dt; 
T2=T0+dt;

randseq=randi(rangeJump,Nbeats,1); % randomize much more than needed

myseq=zeros(Nbeats,1);
myseq(1)=T0;
tos=rand(1,1)>0.5; % flip a coin to decide if the first phase change is positive or negative

pos=1; %"To begin at the beginning, It is Spring, moonless night in the small town..." 
for I=1:length(randseq),
    jump=randseq(I); % the next jump
    
    if (mod(tos+I,2)==0) % alternate systematically between the two
        nT=T2;
    else
        nT=T1;
    end
    
    topos=min(pos+jump,Nbeats); % make sure we do not cross the end point
    myseq((pos+1):topos)=T0; %pad in main inter-onset interval
    
    if (topos<Nbeats) %put the next phase change
        myseq(topos)=nT;
    end
    
    pos=pos+jump; % move to next flip position
    
    if pos>Nbeats
        break;
    end
    
end

% assign final output variables
myplaces=cumsum(myseq);myplaces=1+myplaces-myplaces(1);
OS=myplaces;
S=myseq;
     
end


