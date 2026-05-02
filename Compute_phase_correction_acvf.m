%%%%%%%%%%%%%%%%%%%%
% this function compute that anlytical biased estiamte of the acvf
% NOTE: this will work only for the isochronous case.
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
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

function [gvec]=Compute_phase_correction_acvf(N,alpha,st,sm) 
% compute moments (biased) 
% see: Diedrichsen, Ivry et al. (2003); p.37

g0t=(st*st + 2*sm*sm - 2*(1-alpha)*sm*sm)/(1-(1-alpha)*(1-alpha));
g1t=(1-alpha)*g0t - sm*sm;
g2t=(1-alpha)*g1t;
g3t=(1-alpha)*g2t;
ggvec=zeros(N,1);
ggvec(1:4)=[g0t;g1t;g2t;g3t];
for II=5:N,
    ggvec(II)=ggvec(II-1)*alpha;
end

% compute biased matrix
% Vorberg and Schulze (2002) (eq. 19 p. 76)
M=zeros(N,N);
for j=0:(N-1),
    sofar=2*N-2*j;
    for k=0:(N-1),
        if (j==0)
          b1=N;
          a1=N-k;
        else
          b1=(2*N-2*j);
          a1=sofar;
          l=min(k,N-k-1);
          if l+(N-(2*l+1))<j
              sofar=sofar-0;
          else
            if j<=l
                   sofar=sofar-2;
            else
                      sofar=sofar-1;
            end
          end
          
        end
        M(k+1,j+1)= (-2)/(N*(N-k))*a1 + b1/(N*N);
    end
end
M=M+eye(N);

% apply bias
gout=(M)*ggvec;
gvec=gout(1:3)';
end


