%%%%%%%%%%%%%%%%%%%
% This method computes the bGLS for period correction and multiple persons.
% this function uses the main method in the paper. 
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
%
% Let OR(t) be the response onset at time t
% Let OS(t) be the stimulus onset at time t
% Let R(t) be the interesponse interval R(t)=OR(t)-OR(t-1)
% Let A(t) be the asynchornies A(t)=OR(t)-OS(t)
% note that R is is slightly diffrent than the notation of 
% Vorberg and Shultze 2002 where:
% I(t)=OR(t+1)-OR(t)=R(t+1)
% for multiple person the input of As is a N by P asynchronies
% R is again N by 1 vector (we look at one subject).
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
function [alphas,betas,st,sm]=bGLS_period_model_single_and_multipeson_integ(R,As,MEAN_A,MEAN_R)

% parameters of GLS method
ITER=20; % number of iterations
TRESH=1e-3; %when changes betwen iterations are smaller than this, stop!

N=size(R,1)-2; % number of samples
P=size(As,2);  % number of partners
assert(size(R,1)==size(As,1));
Kratio=2; %The bound is st^2>Kratio*sm^2 - default value=1 --> st>sm

esI=nan(size(As));
for p=1:P,
    esI(:,p)=cumsum(As(:,p));
end

for p=1:P,
    esI(:,p)=esI(:,p)-mean(esI(:,p));
end

for p=1:P,
     As(:,p)=As(:,p)-MEAN_A(p);
%     As(:,p)=As(:,p)-mean(As(:,p)); %compute outside to maximize accuracy
end




b3=R(3:end)-MEAN_R;           % create the matrices
A3=[As(2:end-1,:),esI(2:end-1,:)];
    
% init acvf
K11=1;
K12=0;

zold=zeros(2*P,1)-9999; %init to invalid value

% do the BGLS iterations
for iter=1:ITER,
        CC=diag(K11*ones(1,N),0)+ diag(K12*ones(1,N-1),1) + diag(K12*ones(1,N-1),-1);
        iC=inv(CC);
        z=inv((A3')*iC*A3)*((A3')*iC*b3); % compute GLS
        d=A3*z-b3; % compute residual noise
        
        K=cov(d(1:(end-1)),d(2:end));    %estimate residual acvf
        K11=(K(1,1)+K(2,2))/2;
        K12=K(1,2);

        % apply bound
        if K12>0
            K12=0;
        end
        if K11<(-3*K12)
            K11=(-3*K12);
        end
       
        % if allready obtain local maxima there is no point to continue...
        if (sum(abs(z-zold))<TRESH)
            break;
        end
        zold=z;
end % end of bGLS iterations.
    
%output the values
betas=-z((P+1):(P+P)); 
alphas=-(z(1:P));
sm=sqrt(-K12);
st=sqrt(K11-2*(sm^2));
    
    