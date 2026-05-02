%%%%%%%%%%%%%%%%%%%%%%%
% This function compute a simulation of period adjusting ensemble of
% synchornizers, using the generalization of the Schulze et al. (2005) for
% ensemble of synchornizers
%
% For more details see Jacoby et al. 2014
% =====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015)
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

function  [Rm,Am,ORm] = Simulate_period_correction_ensemble(init_tempo,N,alphaMAT,betaMAT,sigmaTs,sigmaMs)
P=length(sigmaMs);
assert(size(sigmaTs,2)==P);
assert(size(sigmaMs,2)==P);
assert(size(sigmaTs,1)==1);
assert(size(sigmaMs,1)==1);

assert(size(alphaMAT,1)==P);
assert(size(alphaMAT,2)==P);
assert(size(betaMAT,1)==P);
assert(size(betaMAT,2)==P);
Tn=repmat(sigmaTs,[N+1 1]) .* randn(N+1,P);
Mn=repmat(sigmaMs,[N+2 1]) .* randn(N+2,P);
Hn=Tn(2:end,1:P)-Tn(1:(end-1),1:P) + Mn(3:end,1:P)- 2*Mn(2:(end-1),1:P) + Mn(1:(end-2),1:P);

ORm=zeros(N,P);
Rm=zeros(N,P);
Am=cell(N,1);

ORm(1:2,1:P)=repmat([0;init_tempo],[1 P]);
Rm(1:2,1:P)=repmat([init_tempo;init_tempo],[1 P]);

Am{1}=zeros(P,P);
for K=1:2;
    for I=1:P,
        for J=1:P
            Am{K}(I,J)=ORm(K,I)-ORm(K,J);
        end
    end
end


for K=(2):(N-1),
    for I=1:P,
        ORm(K+1,I)=ORm(K,I)+Hn(K,I) + Rm(K,I)+ sum ((-alphaMAT(I,:)-betaMAT(I,:)).*Am{K}(I,:) + (alphaMAT(I,:)).*Am{K-1}(I,:));
        Rm(K+1,I)=ORm(K+1,I)- ORm(K,I);
        
    end
    
    for I=1:P,
        for J=1:P
            Am{K+1}(I,J)=ORm(K+1,I)-ORm(K+1,J);
        end
    end
    

end

