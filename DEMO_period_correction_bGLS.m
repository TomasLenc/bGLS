%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DEMO: simulating the bGLS for period correction
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
%
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

clear all;close all;clc %"To begin at the beginning, It is Spring, moonless night in the small town..." 

SIMULATION_REPEATS=100; % how many repetitions of the simulation to compute.

st=sqrt(100); % parameters chosen according to Vorberg and Schulze (2002) table 1.
sm=sqrt(25);
N=100;
nseq=1;


alphaS=[0.1:0.2:1.1]; % estimate multiple values of alpha
betaS=[0.1,0.5,0.9];  % estimate multiple values of beta


%pertubation squence parameters
T1=445; % first tempo
T2=555; % second tempo
rangeJump=[8,12]; % every 8-12 beats there is a perturbation

% summary variables for estiamtes.
estimates_alpha=nan(SIMULATION_REPEATS,length(alphaS),length(betaS));
estimates_beta =nan(SIMULATION_REPEATS,length(alphaS),length(betaS));
estimates_st=nan(SIMULATION_REPEATS,length(alphaS),length(betaS));
estimates_sm=nan(SIMULATION_REPEATS,length(alphaS),length(betaS));

for KK=1:SIMULATION_REPEATS,
    display(sprintf('simulating %d of %d...', KK,SIMULATION_REPEATS));
    
    
    for J=1:length(betaS)
        for I=1:length(alphaS)
            alpha=alphaS(I); %choose alpha
            beta=betaS(J); %choose beta
            
            alphaEs=nan(nseq,1);
            betaEs=nan(nseq,1);
            stEs=nan(nseq,1);
            smEs=nan(nseq,1);
            for II=1:nseq,
                [S,OS]=create_2StepsSequence(N,T1,T2,rangeJump); % create pertubing sequence
                [Rm,Am,OSm,ORm,Tm] = Simulate_period_correction(S,alpha,beta,st,sm); % model Schulze et al. (2005);
                MEAN_A=mean(Am); % compute empirical mean (Negative mean asynchrony);
                MEAN_R=mean(Rm);
                
                % Compute bGLS estimates
                % use the method in the appendix (not recomanded):
%                 [alphaE,betaE,stE,smE]=bGLS_period_model_single_and_multipeson_diffmethod(Rm,Am,MEAN_A);
                
                % use the version of the main paper:
                 [alphaE,betaE,stE,smE]=bGLS_period_model_single_and_multipeson_integ(Rm,Am,MEAN_A,MEAN_R);

                
                % register results in aggregator for all nseq sequnces.
                alphaEs(II)=alphaE;
                betaEs(II)=betaE;
                stEs(II)=stE;
                smEs(II)=smE;
            end
            estimates_alpha(KK,I,J)=mean(alphaEs); % register resutls
            estimates_beta (KK,I,J)=mean(betaEs); % register resutls
            estimates_st(KK,I,J)=mean(stEs);
            estimates_sm(KK,I,J)=mean(smE);
        end
    end
    
end
%%

%%% plot summary graphs
figure(1);clf;
subplot(2,2,1);
mylegend=cell(length(betaS)+1,1);
for J=1:length(betaS),
    errorbar(alphaS,mean(estimates_alpha(:,:,J),1),std(estimates_alpha(:,:,J),1),'LineWidth',1.5);hold all;
    mylegend{J,1}=sprintf('beta= %2.2g',betaS(J));
end
mylegend{length(betaS)+1}='True alpha';
plot(alphaS,alphaS,'g--','LineWidth',2);hold on;
legend(mylegend,'Location','NorthWest');
xlabel('True alpha');
ylabel('Estimated alpha');
title('estimating alpha');
axis([min(alphaS-0.1) max(alphaS+0.1) min(alphaS-0.2) max(alphaS+0.2)]);

subplot(2,2,2);
mylegend=cell(length(alphaS)+1,1);
for J=1:length(alphaS),
    errorbar(betaS,mean(estimates_beta(:,J,:),1),std(estimates_alpha(:,J,:),1),'LineWidth',1.5);hold all;
    mylegend{J,1}=sprintf('alpha= %2.2g',alphaS(J));
end
mylegend{length(alphaS)+1}='True alpha';
plot(betaS,betaS,'g--','LineWidth',2);hold on;
legend(mylegend,'Location','NorthWest');
xlabel('True beta');
ylabel('Estimated \beta');
title('Estimating beta');
axis([min(alphaS-0.1) max(alphaS+0.1) min(betaS-0.2) max(betaS+0.2)]);


subplot(2,2,3);
mylegend=cell(length(betaS)+1,1);
for J=1:length(betaS),
    errorbar(alphaS,mean(estimates_st(:,:,J),1),std(estimates_st(:,:,J),1),'LineWidth',1.5);hold all;
    mylegend{J,1}=sprintf('beta= %2.2g',betaS(J));
end
mylegend{length(betaS)+1}='True \sigma_T';
plot(alphaS,ones(size(alphaS))*st,'g--','LineWidth',2);hold on;
legend(mylegend,'Location','NorthWest');
xlabel('True alpha');
ylabel('Estimated \sigma_T');
title('Estimating \sigma_T');
axis([min(alphaS-0.1) max(alphaS+0.1) 0 22]);

subplot(2,2,4);
mylegend=cell(length(betaS)+1,1);
for J=1:length(betaS),
    errorbar(alphaS,mean(estimates_sm(:,:,J),1),std(estimates_sm(:,:,J),1),'LineWidth',1.5);hold all;
    mylegend{J,1}=sprintf('beta= %2.2g',betaS(J));
end
mylegend{length(betaS)+1}='True \sigma_M';
plot(alphaS,ones(size(alphaS))*sm,'g--','LineWidth',2);hold on;
legend(mylegend,'Location','NorthWest');
xlabel('True alpha');
ylabel('Estimated \sigma_M');
title('Estimating \sigma_M');
axis([min(alphaS-0.1) max(alphaS+0.1) 0 22]);

