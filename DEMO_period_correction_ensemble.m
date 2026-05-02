%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this demo shows how the phase bGLS can solve ensemble synchronization with
%period and phase adjustments
%problem. Data was simulate dto mimic Wing et al. (2014) (but with period
%correction and changing base tempo.
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
%
% Note that in practice large (extreme values) should be replaces by the
% mean.
% (something like: pos=abs(A)>200;A(pos)=MEAN_A; R(pos)=MEAN_R )
%
% more details are in Jacoby et al. (2014).
% =====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;close all;clc; %"To begin at the beginning, It is Spring, moonless night in the small town..." 
init_tempo=500;
N=40; % number of beats in each block
nseq=16; % number of experimental blocks
SIMULATION_REPEATS=100;


alphaMAT=[0,0.3,0.1,0;0.3,0,0.1,0;0.3,0.1,0,0.2;0.1,0,0.3,0.2]; %selected coupling phase
betaMAT=[0.3,0.2,0.2,0.3;0.1,0,0,0.2;0.3,0,0.2,0.1;0.1,0.1,0.2,0];    %selected coupling period
sigmaTs=[10,13,15,18]; % selected timekeeper std
sigmaMs=[5,6,7,8];     % selected motor std

NAMES={'v1','v2','vla','vlc'}; %Names of ensemble members (for output).

NA=16-4+16-4+4+4; % total number of free parameters in the model.

% aggregator for results
resA=zeros(SIMULATION_REPEATS,NA);% agregator for all the results (all paramters).
resNames=cell(NA,1); %names of paramters
resT=zeros(1,NA);    %true values of parameters
for KK=1:SIMULATION_REPEATS, 
    display(sprintf('%d of %d',KK,SIMULATION_REPEATS));
    res=zeros(nseq,NA); % this is the aggregator only for the nseq repetitions 
    for seq=1:nseq,
        
        % simulate ensemble (with coupled period and phase).
        [Rm,Am,ORm] = Simulate_period_correction_ensemble(init_tempo,N,alphaMAT,betaMAT,sigmaTs,sigmaMs);

        aE=zeros(4,4);
        bE=zeros(4,4);
        smE=zeros(4,1);
        stE=zeros(4,1);

        % for all subjects compute variables of synchronization to subject SUBJ<---    
        for SUBJ=1:4, 

            %prepare data set for estimation
            R=Rm(:,SUBJ);
            As=zeros(size(R,1),3);
            others=setdiff(1:4,[SUBJ]);
            assert(length(others)==3);
            for K=1:length(Am),
                As(K,1)=Am{K}(SUBJ,others(1));
                As(K,2)=Am{K}(SUBJ,others(2));
                As(K,3)=Am{K}(SUBJ,others(3));
            end

            MEAN_A=mean(As);
            MEAN_R=mean(R);
            
                            % Compute bGLS estimates
                % use the method in the appendix (not recomanded):
%                  [alphas,betas,st,sm]=bGLS_period_model_single_and_multipeson_diffmethod(R,As,MEAN_A);
                
                % use the version of the main paper:
              [alphas,betas,st,sm]=bGLS_period_model_single_and_multipeson_integ(R,As,MEAN_A,MEAN_R);
            
            

            % register estimates
            aE(SUBJ,others)=alphas;
            bE(SUBJ,others)=betas;
            smE(SUBJ)=sm;
            stE(SUBJ)=st;
        end

        % agregate all data into variables
        cnt=0;
        for I=1:4,
            for J=1:4,
                if I~=J
                    cnt=cnt+1;
                    res(seq,cnt)=aE(I,J);
                    resNames{cnt}=sprintf('%s<-%s',NAMES{I},NAMES{J});
                    resT(cnt)=alphaMAT(I,J);
                end
            end
        end
        for I=1:4,
            for J=1:4,
                if I~=J
                    cnt=cnt+1;
                    res(seq,cnt)=bE(I,J);
                    resNames{cnt}=sprintf('%s<-%s',NAMES{I},NAMES{J});
                    resT(cnt)=betaMAT(I,J);
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

    end % finish rendering the nseq trials
    
    % agregate the final results (mean of nseq trials)
    if nseq>1
    resA(KK,:)=mean(res);
    else
        resA(KK,:)=res;
    end
    
end
clear res % we don't need it - the results are in resA

%% this  plots the obtained results. it is recomanded to maximize window and then run again for better graphics.
figure(2);clf;
subplot(2,1,1);
bef=1:(NA-8);
aft1=((NA-8)+1):(NA-4);
aft2=((NA-4)+1):NA;
% bar(bef,(resT(bef)));hold on;
bar(bef(1:12),(resT(bef(1:12))),'c');hold on;
bar(bef(13:24),(resT(bef(13:24))),'m');hold on;

errorbar(bef,mean(resA(:,bef)),std(resA(:,bef)),'ro');
set(gca,'XTick',bef);
set(gca,'XTickLabel',{resNames{bef,1}},'Fontsize',10);
% xticklabel_rotate([],90,{resNames{bef,1}},'Fontsize',10); %this is for fancier output taken from a code by Denis Gilbert
% if you want to use it: 
% xticklabel_rotate.m use the software by Denis Gilbert please see http://www.qc.dfo-mpo.gc.ca/iml/ for more information.

% you can ignore it bu then the legend will look less nice.
title('Coupling constants');
ylabel('Estimated \alpha and \beta');
legend('Simulated alphas','Simulated betas','Estimations');

subplot(2,1,2);
bar(1:4,(resT(aft1)),'b');hold on;
bar(5:8,(resT(aft2)),'r');hold on;
errorbar(1:4,mean(resA(:,aft1)),std(resA(:,aft1)),'ro');hold on;
errorbar(5:8,mean(resA(:,aft2)),std(resA(:,aft2)),'ko');
set(gca,'XTick',1:8);
set(gca,'XTickLabel',resNames([aft1,aft2]));
title('Noise terms (standard deviation)');
ylabel('Estimated standard deviations');
legend('True timekeeper std','True motor std','Estimated timekeeper std','Estimated motor std')
