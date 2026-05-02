%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function simulate a sequence based on the model proposed
% by Vorberg & Schulze 2002, an equivalent formula was proposed by 
% Repp, Keller and Jacoby 2012 and is used here.
%
% input:
% interstimulus intervals S
%note that S is unconventional since S(t)=OS(t)-OS(t-1) 
% and not like Vorberg and Schulze 2002 where C(t)=OS(t+1)-OS(t) =S(t+1)
% alpha - phase correction parameter
% sigmaM, sigmaT - motor and internal time-keeper standard deviations
% respectively. 
%
% The model takes the form (proof in the appendix in Repp, Keller and Jacoby 2012:
% R(n+1)= -alpha* A(n) + tau + T(n)+M(n+1)-M(n)
% where tau=mean(s) the mean of the inter-time keeper
%
% an equivalent formula is:
% S(n+1)+A(n+1)=(1-alpha)*A(n) + tau + T(n)+M(n+1)-M(n)
%
% output:
% OSm,ORm - modeled stimulus,repsomse onsets (msec)
%
% Rm-  modeled interesponse interval Rm(t)=ORm(t)-ORm(t-1) 
% note that this is unconventional, see previoua remark about S(t)
% 
% Am - modeled asynchrony: Am(t)=ORm(t)-OSm(t)
% 
% Written by Nori Jacoby, for help please contact: nori.viola@gmail.com
%
% [Vorber et. al 2002] Vorberg, D., & Schulze, H. -H. (2002).
%   "Linear phase-correction in synchronization: Predictions,
%    parameter estimation, and simulations"
% Journal of Mathematical Psychology, 46, 56–87.
%
% [Repp et. al 2012] Repp, B. H., Keller, P. E., & Jacoby, N. (2012). 
%"Quantifying phase correction in sensorimotor synchronization: empirical comparison of three paradigms"
%. Acta Psychologica, 139, 281-290..
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

function  [Rm,Am,OSm,ORm] = Simulate_phase_correction_non_isochronous(S,alpha,sigmaT,sigmaM)


assert(sum(S<=0)==0);

N=length(S);
OSm=cumsum(S);
tau=mean(S);

Am=nan(N,1);
Rm=nan(N,1);
ORm=nan(N,1);

Tn=sigmaT*randn(N,1);
Mn=sigmaM*randn(N+1,1);

Hn=Tn+Mn(2:(end)) - Mn(1:(end-1));


ORm(1)=OSm(1)+Hn(1);
Rm(1)=S(1);
Am(1)=ORm(1)-OSm(1);

for K=(1):(N-1),
    ORm(K+1)=ORm(K)+Hn(K) + (-alpha)*Am(K) + tau;
    Am(K+1)=ORm(K+1)-OSm(K+1);
    Rm(K+1)=ORm(K+1)- ORm(K);
end
