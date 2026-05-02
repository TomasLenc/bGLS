%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DEMO: simulating the bGLS for non-isochronous sequecne 
%%%%   For more information see: Nori Jacoby, Peter E. Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby (2015) 
%%=====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


st=sqrt(100); % parameters chosen according to Vorberg and Schulze (2002) table 1.
sm=sqrt(25);
N=30;
nseq=15;


alphaS=[0.1:0.1:1.2]; % estimate multiple values of alpha
SIMULATION_REPEATS=50; % how many repetitions of the simulation to compute.


%pertubation squence parameters
T0=500; % base tempo in msec
dt=50; %pertubation difference in msec 
rangeJump=[8,12]; % every 8-12 beats there is a perturbation

% summary variables for estiamtes.
estimates_alpha=nan(SIMULATION_REPEATS,length(alphaS));
estimates_st=nan(SIMULATION_REPEATS,length(alphaS));
estimates_sm=nan(SIMULATION_REPEATS,length(alphaS));
for KK=1:SIMULATION_REPEATS,
    display(sprintf('simulating %d of %d...', KK,SIMULATION_REPEATS));
    for I=1:length(alphaS)
        alpha=alphaS(I); %choose alpha
        
        alphasEs=nan(nseq,1);
        stEs=nan(nseq,1);
        smEs=nan(nseq,1);
        for II=1:nseq,


            [S,OS]=create_PhaseSequence(N,T0,dt,rangeJump);% create phase perurbtation sequcne
            [Rm,Am,OSm,ORm] = Simulate_phase_correction_non_isochronous(S,alpha,st,sm);% simualte once
            MEAN_R=mean(Rm);
            MEAN_A=mean(Am);

            [alphaE,stE,smE]=bGLS_phase_model_single_and_multiperson(Rm,Am,MEAN_A,MEAN_R);
            alphasEs(II)=alphaE;
            stEs(II)=stE;
            smEs(II)=smE;
        end
        estimates_alpha(KK,I)=mean(alphasEs); % register resutls
        estimates_st(KK,I)=mean(stEs);
        estimates_sm(KK,I)=mean(smE);
    end
    
end
%%
%%% DRAW 
figure(1);clf;
subplot(3,1,1);
plot(alphaS,alphaS,'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_alpha),std(estimates_alpha),'k-','LineWidth',1.5);
xlabel('True alpha');
ylabel('Estimated alpha');
title('alpha estimation');
axis([min(alphaS) max(alphaS) (-.2+min(alphaS)) (.2+max(alphaS))]);

subplot(3,1,2);
plot(alphaS,st*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_st),std(estimates_st),'k-','LineWidth',1.5);
xlabel('True alpha');
title('\sigma_T estimation');
ylabel('Estimated \sigma_T');
axis([min(alphaS) max(alphaS) 0 20]);

subplot(3,1,3);
plot(alphaS,sm*ones(size(alphaS)),'g--','LineWidth',2);hold on;
errorbar(alphaS,mean(estimates_sm),std(estimates_sm),'k-','LineWidth',1.5);
xlabel('True alpha');
title('\sigma_M estimation');
ylabel('Estimated \sigma_M');

axis([min(alphaS) max(alphaS) 0 20]);
