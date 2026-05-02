%%%%%%%%%%%%%%%%%%%
% This method computes the unbounded bGLS for the case of isochronous
% sequence.
% DO NOT USE THIS IN PRACTICE! 
% this is only to show that without the constraint on the motor and
% timekeeper varaince the estimation is NOT good!
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
%
% Let OR(t) be the response onset at time t
% Let OS(t) be the stimulus onset at time t
% Let A(t) be the asynchronie A(t)=OR(t)-OS(t)
%
% the empirical means should be computed outside.
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

function [alpha,st,sm]=bGLS_phase_isochronous_only_unbounded(As,MEAN_A)
ITER=20;
TRESH=1e-3;

N=size(As,1);  % retrive parameters
nseq=size(As,2);

% esm=As-repmat(mean(As), [N 1]); % reduce the empirical mean.
esm=As-MEAN_A;

b=esm(2:N,:);  % compute matrices.
B=esm(1:(N-1),:);

% compute agregator for all repeats
alpha_s=nan(1,nseq);
st_s=nan(1,nseq);
sm_s=nan(1,nseq);

for KK=1:nseq,
 b1= b(:,KK);   
 B1= B(:,KK);
 
 z=mldivide (B1,b1);
 zold=z;
 % perform multiple iterations of the bGLS method
 for II=1:ITER,
     d=b1-B1*z; % compute residual noise
     K=cov(d(1:(end-1)),d(2:end));    
     K11=(K(1,1)+K(2,2))/2;
     K12=K(1,2);
%         
% This part where we suppose to apply the constraint is commented out!
% because in this version we do NOT apply the constraint!
%      % apply bound of the bGLS  % 
%      if K12>0
%          K12=0;
%      end
%      if K11<3*(-K12)
%          K11=-3*K12;
%      end
         
     % calculate GLS  with known covariance
     CC=diag(K11*ones(1,N-1),0)+ diag(K12*ones(1,N-2),1) + diag(K12*ones(1,N-2),-1);
     iC=inv(CC);

     z=inv((B1')*iC*B1)*(B1')*iC*b1; % compute GLS
    
     if(max(abs(z-zold))<TRESH)
        break;
     end
    zold=z;
 end
  
 %compute trial values
 alpha_s(KK)=1-z;
 sm_s(KK)=sqrt(abs(K12)+eps);
 st_s(KK)=sqrt(abs(K11-2*(sm_s(KK)^2)));
end

% compute final values (mean of all nseq trials)
% truncate extreme values.
alpha=mean(alpha_s);
if alpha>2
    alpha=2;
end
if alpha<-1
    alpha=-1;
end
st=mean(st_s);
sm=mean(sm_s);