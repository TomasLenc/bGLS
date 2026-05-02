%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this demo shows how the phase bGLS can solve ensemble synchronization
%problem. Data was simulate to mimic Wing et al. (2014).
%
% Note that in practice large (extreme values) should be replaces by the
% mean.
% (something like: pos=abs(A)>200;A(pos)=MEAN_A; R(pos)=MEAN_R )
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
% =====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
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

clear all;close all;clc; %"To begin at the beginning, It is Spring, moonless night in the small town..." 

init_tempo=170; 
% init_tempo=500; 
N=40; %number of beats in each block
nseq=16; %number of experimental blocks

%this matrix has in position alphaMAT(I,J) the coupling constant of subject
%I listen to subject J.
alphaMAT=[0,0.3,0.1,0;0.3,0,0.1,0;0.3,0.1,0,0.2;0.1,0.1,0.4,0.2];
sigmaMs=[5,6,7,8];
sigmaTs=[10,13,15,18];

SIMULATION_REPEATS=100; % number of simulation interations

NA=16-4+4+4; % number of paramters of the mdoel
NAMES={'vln1','vln2','vla','vlc'}; % names of ensemble members


resA=zeros(SIMULATION_REPEATS,NA);% aggregator of model variables.
resNames=cell(NA,1); % names of parameters
resT=zeros(1,NA);    % the true parameters
for KK=1:SIMULATION_REPEATS,
    display(sprintf('%d of %d',KK,SIMULATION_REPEATS));
    res=zeros(nseq,NA); %aggregator of model variables for all nseq reptitions
    for seq=1:nseq,% allow more then one SIMULATION_REPEATSition
              [Rm,Am,ORm] = Simulate_phase_correction_ensemble(init_tempo,N,alphaMAT,sigmaTs,sigmaMs);

              %initialize trial estimates
            alphaE=zeros(4,4);
            smE=zeros(4,1);
            stE=zeros(4,1);

        % for all subjects compute variables of synchronization to subject SUBJ<---    
        for SUBJ=1:4,

            %prepare dataset
            R=Rm(:,SUBJ);
            As=zeros(size(R,1),3);
            others=setdiff(1:4,[SUBJ]);
            assert(length(others)==3);
            for K=1:length(Am),
                As(K,1)=Am{K}(SUBJ,others(1));
                As(K,2)=Am{K}(SUBJ,others(2));
                As(K,3)=Am{K}(SUBJ,others(3));
            end

            % do bGLS
            MEAN_A=mean(As);
            MEAN_R=mean(R);
            [alphas,st,sm]=bGLS_phase_model_single_and_multiperson(R,As,MEAN_A,MEAN_R);

            %register results
            alphaE(SUBJ,others)=alphas;
            smE(SUBJ)=sm;
            stE(SUBJ)=st;
        end

        %%%%%%% this code simply align all the results into one aggregator
        %%%%%%% this aggregator holds nseq lines of all prameters
        %%%%%%% we later take the average
        %%%%%%% note that resT and resNames are set many many times...
        cnt=0;
        for I=1:4,
            for J=1:4,
                if I~=J
                    cnt=cnt+1;
                    res(seq,cnt)=alphaE(I,J);
                    resNames{cnt}=sprintf('%s<-%s',NAMES{I},NAMES{J});
                    resT(cnt)=alphaMAT(I,J);
                end

            end
        end
        for I=1:4,
            cnt=cnt+1;
            res(seq,cnt)=stE(I);
            resNames{cnt}=sprintf('sigma_T(%s)',NAMES{I});
            resT(cnt)=sigmaTs(I);
        end
        for I=1:4,
            cnt=cnt+1;
            res(seq,cnt)=smE(I);
            resNames{cnt}=sprintf('sigma_M(%s)',NAMES{I});
            resT(cnt)=sigmaMs(I);
        end
        assert(cnt==NA);
    end %%%%% end of running it for nseq iteration
    
    % average across nseq iteration and agregate results in the final
    % aggregator resA.
        if nseq>1
    resA(KK,:)=mean(res);
    else
        resA(KK,:)=res;
    end
    
end
clear res % we don't need it! the results are in (resA)...
 
%%%% Plot Graphs of estimated and true results
figure(1);clf;
subplot(2,1,1);
bef=1:(16-4);
aft1=((NA-8)+1):(NA-4);
aft2=((NA-4)+1):NA;
 
bar(bef,(resT(bef)));hold on;
errorbar(bef,mean(resA(:,bef)),std(resA(:,bef)),'ro');

set(gca,'XTick',bef);
set(gca,'XTickLabel',{resNames{bef,1}});
title('Coupling constants (\alpha)');
ylabel('Estimated \alpha');
legend('True values','Estimations');

subplot(2,1,2);
bar(1:4,(resT(aft1)),'b');hold on;
bar(5:8,(resT(aft2)),'r');hold on;
errorbar(1:4,mean(resA(:,aft1)),std(resA(:,aft1)),'ro');
errorbar(5:8,mean(resA(:,aft2)),std(resA(:,aft2)),'ko');

set(gca,'XTick',1:8);
set(gca,'XTickLabel',resNames([aft1,aft2]));
legend('Timekeeper std','Motor std')

title('Noise terms (standard deviation)');
ylabel('Estimated standard deviation');
