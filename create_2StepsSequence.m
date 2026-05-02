%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function creates a stimulus that is similar to the experimental one
% used for 2 steps experiment in Jacoby and Repp 2012
%
% output:
% OS(t) is the stimulus onset
% S(t) is the inter-stimulus interval
%
%note that s is unconventional since S(t)=OS(t)-OS(t-1) 
% and not like Vorberg and Shultze 2002 where C(t)=S(t+1)-S(t) 
%
% input:
% T1, T2 are the two inter-stimulus inteval that the 2 steps experiment
% alternate between
% rangeJump is a vector of the form [n1,n2] and this is range of beats 
% before next alteration of tempo.
% Nbeats is the total number of beats
%
% Written by Nori Jacoby, for help please contact: nori.viola@gmail.com
%
% [Jacoby and Repp 2012]  Nori and Bruno H. Repp.
% “A General Linear Framework for the Comparison and Evaluation of Models of Sensorimotor Synchronization.” 
% Biological Cybernetics, vol. 106/3, 135-154, DOI: 10.1007/s00422-012-0482-x.
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

function [S,OS]=create_2StepsSequence(Nbeats,T1,T2,rangeJump)

% set default values 
if isempty(Nbeats)
    Nbeats=100;
end

if (isempty(T1)||isempty(T2)) % match one of the cases from Jacoby and Repp 2012
    T1=445;
    T2=555;
end

if isempty(rangeJump) % match Jacoby and Repp 2012
 rangeJump=[8 12];      
end

   
randseq=randi(rangeJump,Nbeats,1); % randomize much more than needed

tos=rand(1,1)>0.5; % flip a coin to choose which tempo to start
myseq=zeros(Nbeats,1); %reset sequence
T0=T1*tos + T2*(1-tos); % start with one of the tempi

pos=1; %"To begin at the beginning, It is Spring, moonless night in the small town..." 
for I=1:length(randseq),
    jump=randseq(I); %length of next jump
    if (T0==T1) % flip tempi
        T0=T2;
    else
        T0=T1;
    end
    topos=min(pos+jump,Nbeats); %if we are at the end of the sequence - this is enought!
    myseq(pos:topos)=T0; %pad with current tempo
    pos=pos+jump; %move to next position
    
    if pos>Nbeats % this it!
        break;
    end
    
end

%make output from temporary variables
myplaces=cumsum(myseq);OS=1+myplaces-myplaces(1);
S=myseq;
    
end
