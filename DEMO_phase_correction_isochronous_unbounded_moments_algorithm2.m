%%% DEMO: simulating the unboudned moments method (algorithm 2 in the paper)
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015)
%%=====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%%%%%%%%%%%%
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
alphaS=sort([0.1:0.1:1.1]); % estimate multiple values of alpha

st=sqrt(100); % parameters chosen according to Vorberg and Schulze (2002) table 1.
sm=sqrt(25);
sT=st;
sM=sm;
N=30;
nseq=15;

MEAN_e=0; %zero mean since this is simulated... In real data compute it based on maximal amount of possible data avilable

SIMULATION_REPEATS=100; % how many repetitions of the simulation to compute.

% summary variables for estiamtes.
estimates_alpha=nan(SIMULATION_REPEATS,length(alphaS));
estimates_st=nan(SIMULATION_REPEATS,length(alphaS));
estimates_sm=nan(SIMULATION_REPEATS,length(alphaS));
for KK=1:SIMULATION_REPEATS,
    display(sprintf('simulating %d of %d...', KK,SIMULATION_REPEATS));
    for I=1:length(alphaS)
        alpha=alphaS(I);
        As=Simulate_phase_correction_isochronous(N,nseq,alpha,st,sm) ; % simualte once
        [alphaE,stE,smE]=Compute_unbounded_Phase_isochronous_only(As); % estimate once
        
        estimates_alpha(KK,I)=alphaE; % register resutls
        estimates_st(KK,I)=stE;
        estimates_sm(KK,I)=smE;
    end
end
%%
%%% DRAW
figure(1);clf

subplot(3,1,1);
plot(alphaS,alphaS,'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_alpha),std(estimates_alpha),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated alpha');
axis([min(alphaS) max(alphaS) (-.2+min(alphaS)) (.2+max(alphaS))]);


subplot(3,1,2);
plot(alphaS,(st.^2)*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_st.^2),std(estimates_st.^2),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated {\sigma_T}^2');
axis([min(alphaS) max(alphaS) -50 200]);

subplot(3,1,3);
plot(alphaS,(sm.^2)*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_sm.^2),std(estimates_sm.^2),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated {\sigma_M}^2');
axis([min(alphaS) max(alphaS) -50 200]);

tabVS=[0.2,0.193,0.067,25.13,12.0,100.80,21.3]; %15
subplot(3,1,1);
errorbar(tabVS(1),tabVS(2),tabVS(3),'dm','MarkerFaceColor','m','LineWidth',1.5)
title('alpha estimation');
subplot(3,1,2);
errorbar(tabVS(1),(tabVS(6)),(tabVS(7)),'dm','MarkerFaceColor','m','LineWidth',1.5)
title('{\sigma_T}^2 estimation');
subplot(3,1,3);
errorbar(tabVS(1),(tabVS(4)),(tabVS(5)),'dm','MarkerFaceColor','m','LineWidth',1.5)
title('{\sigma_M}^2 estimation');
%%
alphaS=sort(0.828); % estimate special values of alpha alpha_OPT

% summary variables for estiamtes.
estimates_alpha=nan(SIMULATION_REPEATS,length(alphaS));
estimates_st=nan(SIMULATION_REPEATS,length(alphaS));
estimates_sm=nan(SIMULATION_REPEATS,length(alphaS));
for KK=1:SIMULATION_REPEATS,
    display(sprintf('simulating %d of %d...', KK,SIMULATION_REPEATS));
    for I=1:length(alphaS)
        alpha=alphaS(I);
        As=Simulate_phase_correction_isochronous(N,nseq,alpha,st,sm) ; % simualte once
        [alphaE,stE,smE]=Compute_unbounded_Phase_isochronous_only(As); % estimate once
        
        estimates_alpha(KK,I)=alphaE; % register resutls
        estimates_st(KK,I)=stE;
        estimates_sm(KK,I)=smE;
    end
end



figure(1);
subplot(3,1,1);
errorbar(alphaS,mean(estimates_alpha),std(estimates_alpha),'s','Color',[0.5 0.5 0.5],'LineWidth',1,'MarkerFaceColor',[0.5 0.5 0.5]);
title('alpha estimation');
ylabel('Estimated alpha');

subplot(3,1,2);
errorbar(alphaS,mean(estimates_st.^2),std(estimates_st.^2),'s','Color',[0.5 0.5 0.5],'LineWidth',1,'MarkerFaceColor',[0.5 0.5 0.5]);
title('{\sigma_T}^2 estimation');
ylabel('Estimated {\sigma_T}^2');
subplot(3,1,3);
errorbar(alphaS,mean(estimates_sm.^2),std(estimates_sm.^2),'s','Color',[0.5 0.5 0.5],'LineWidth',1,'MarkerFaceColor',[0.5 0.5 0.5]);
title('{\sigma_M}^2 estimation');
ylabel('Estimated {\sigma_M}^2');


