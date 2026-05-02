%%%%%%
% compute the bounded Vorberg_Schulze method using analyitical formula
% works only with isochronous sequnces
% note that we apply here the constraint (algorithm 3 in the paper).
% used for comparing performance
% for practical applications use bGLS version
%   For more information see: Nori Jacoby, Peter E. Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby (2015) 
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

function [alpha,st,sm]=Compute_bounded_Phase_isochronous_only(As)

nseq=size(As,2);
N=size(As,1);

esM=As-repmat(mean(As), [N 1]); % reduce the empirical mean.

% esM=es-MEAN_e; % reduce mean of asynchrony.
% esM=esM-mean(esM); % reduce emprical mean of asynchrony. NOTE!!!


g0M=(var(esM)); %compute moments seperately
g1M=sum(((esM(2:end,:)).*(esM(1:(end-1),:)))/(N-2));
g2M=sum(((esM(3:end,:)).*(esM(1:(end-2),:)))/(N-3));

g0=mean(g0M); %compute the mean estimates
g1=mean(g1M);
g2=mean(g2M);
gvec0=[g0,g1,g2];

% the bound is applied by having st=sm+delta^2 this make sure that st>sm>0.
xfS=fminsearch(@(x) (sum(((Compute_phase_correction_acvf(N,x(1),abs(x(3))+x(2)*x(2),abs(x(3)))-gvec0)).^2)),[0.5,1,20],optimset('MaxFunEvals',10000,'MaxIter',10000));

% reparametrize.
alpha=xfS(1);
st=abs(xfS(3))+xfS(2)*xfS(2); %xfS(2) is delta
sm=abs(xfS(3));

        
        