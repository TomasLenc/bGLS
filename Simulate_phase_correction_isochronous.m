%%%%%%%%%%%%%%%%%%%%%%%
% This function compute a simulation of phase correcting model of Vorberg
% and Wing (1996)
%
% Noise is randomized as Gamma noise but can be replaced in fact with
% Gaussian noise.
%
%   For more information see: Nori Jacoby,Peter E. Keller, Bruno H. Repp, Merav Ahissar and  Naftali Tishby (2015)
%
%The output is a matrix es (N by nseq) with columns as seperate repetitions
%of seperate trials.
% =====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

function As=Simulate_phase_correction_isochronous(N,nseq,alpha,st,sm) 
k=4; %used by most previous works
M=(gamrnd(ones(N+2,nseq)*k,ones(N+2,nseq))-k)/sqrt(k);   % we simulate randomize with Gamma noise
T=(gamrnd(ones(N+2,nseq)*k,ones(N+2,nseq))-k)/sqrt(k);   % Jacoby et al. (2014) show this can be replaced with Gaussian noise.

Z=st*T(1:(N+1),1:nseq)-sm*M(2:(N+2),1:nseq)+sm*M(1:(N+1),1:nseq); % compute residual noise vector.
AA=zeros(N+2,nseq);

%compute together for all nseq sequences.
for I=1:(N+1),
     AA(I+1,1:nseq) =(1-alpha)*AA(I,1:nseq) + Z(I,1:nseq);
end

As=AA(3:(N+2),1:nseq); %output result
end


