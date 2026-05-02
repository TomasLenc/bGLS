==========================================================================
===== Implementation of the bGLS method.
=====
===== For more information see: 
===== 
===== Jacoby, Nori, Peter Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby. 
===== "Parameter Estimation of Linear Sensorimotor Synchronization Models: Phase Correction, Period Correction and Ensemble Synchronization." 
===== Special issue of Timing & Time Perception (RPPW).
======
===== Jacoby, Nori, Naftali Tishby, Bruno H. Repp, Merav Ahissar, and Peter E. Keller. 
===== “Lower Bound on the Accuracy of Parameter Estimation Methods for Linear Sensorimotor Synchronization Models.” 
===== Special issue of Timing & Time Perception (RPPW).
===== 
===== Nori.viola@gmail.com
===== Please cite this paper if you are using this package:
=====  Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015)
=====
===== IMPORTANT: This code is currently (12/14) in beta.
===== Critical updates will be forthcoming.
=====
===== ALL CODE BY: Nori Jacoby (nori.viola@gmail.com)
================================================================
===== http://www.norijacoby.com/bgls.htm
=====
===== http://www.norijacoby.com/ 
===========================================================================

In all functions for single subjects:
OS(t) and OR(t) are stimulus and response onsets.
S(t) and R(t) are inter-response and inter-stimulus intervals.
A(t)=OR(t)-OS(t) is the asynchrony.

In all functions for ensemble subjects:
As is a N (samples in time) by P (other subjects) matrix 
As(t,j)=OR(t)-OS(t,j)
where OR(t) is the current subject response at time t.
OS(t,j) is the other j subject responses at time t

Note a small discrepancy between this notation and Vorberg and Schulze notation:
C(t)=OS(t+1)-OS(t)=S(t+1);


1.	For the single subject phase correction model:
Use:

bGLS_phase_model_single_and_multiperson.m
demo of proper usage is:
DEMO_phase_correction_non_isochronous_bGLS.m


2.	For the ensemble phase correction model:
Use the same method as in single subject.
bGLS_phase_model_single_and_multiperson.m

demo of proper usage is in:
DEMO_phase_correction_ensemble.m

3.	For the single subject period and phase correction model:
Use the method:
bGLS_period_model_single_and_multipeson_integ.m
demo of proper usage is in:
DEMO_period_correction_bGLS.m

4.	For ensemble period and phase correction, use the same method:
bGLS_period_model_single_and_multipeson.m
demo of proper usage is in:
DEMO_period_correction_ensemble.m

The next few demos are not for real data; they can be used to create the simulations reported in the papers.

5.	For comparison with the bounded moments-acvf method (not for real data) use:
Note: this should not be used for real data!
Compute_bounded_Phase_isochronous_only.m
DEMO_phase_correction_isochronous_bounded_moments_algorithm3
unbounded:
DEMO_phase_correction_isochronous_unbounded_moments_algorithm2.m

The last demo uses this internal function for estimation:
bGLS_phase_isochronous_only.m
This variant is used so that it is fully compatible in structure to the 
Compute_bounded_Phase_isochronous_only.m function.

6.	More support functions:
create_PhaseSequence.m create phase correction experiment (see Repp, Keller, and Jacoby 2014).
create_2StepsSequence.m- create period correction experiment (see Jacoby and Repp 2012).
Compute_phase_correction_acvf.m used inside the bounded moments method (algorithm 3). This function computes the analytic formula for biased acvf. It first computes the unbiased acvf and then applies a biased formula.

==========================================================================
===== For information please contact: Nori Jacoby 
===== Nori.viola@gmail.com
=====
===== If you are using the code,
===== Please cite this version:
===== 
===== Jacoby, Nori, Peter Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby. 
===== "Parameter Estimation of Linear Sensorimotor Synchronization Models: Phase Correction, Period Correction and Ensemble Synchronization." 
===== Special issue of Timing & Time Perception (RPPW).
==========================================================================

