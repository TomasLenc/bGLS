%%%%%%%%%%%%
%%% DEMO: simulating the bGLS for isochronous sequnces
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

clear all;close all;clc

alphaS=[0.1:0.1:1.2]; % estimate multiple values of alpha

st=sqrt(100); % parameters chosen according to Vorberg and Schulze (2002) table 1.
sm=sqrt(25);
N=30;
nseq=15;

MEAN_e=0; %zero mean since this is simulated... In real data compute it based on maximal amount of possible data avilable

SIMULATION_REPEATS=50; % how many repetitions of the simulation to compute.

% summary variables for estiamtes.
estimates_alpha=nan(SIMULATION_REPEATS,length(alphaS));
estimates_st=nan(SIMULATION_REPEATS,length(alphaS));
estimates_sm=nan(SIMULATION_REPEATS,length(alphaS));
for KK=1:SIMULATION_REPEATS,
    display(sprintf('simulating %d of %d...', KK,SIMULATION_REPEATS));
    for I=1:length(alphaS)
        alpha=alphaS(I);
        es=Simulate_phase_correction_isochronous(N,nseq,alpha,st,sm) ; % simualte once
        [alphaE,stE,smE]=bGLS_phase_isochronous_only(es,MEAN_e);% estimate once
        estimates_alpha(KK,I)=alphaE; % register resutls
        estimates_st(KK,I)=stE;
        estimates_sm(KK,I)=smE;
    end
end
%%
%%% DRAW results
figure(1);clf;
subplot(3,1,1);
plot(alphaS,alphaS,'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_alpha),std(estimates_alpha),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated alpha');
axis([min(alphaS) max(alphaS) (-.2+min(alphaS)) (.2+max(alphaS))]);

subplot(3,1,2);
plot(alphaS,st*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_st),std(estimates_st),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated st');
axis([min(alphaS) max(alphaS) 0 20]);

subplot(3,1,3);
plot(alphaS,sm*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_sm),std(estimates_sm),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated sm');
axis([min(alphaS) max(alphaS) 0 20]);
