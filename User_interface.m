
%%%%PROJECT CODE
%%
Coding = 'equal'; %Coding: type string: ‘binary’ or ‘equal’
%% valves
N=31;
%% Gain parameters for tuning
Kff=1;%Gain of the controllers Kff and Kp
Kp=10;%Kp=0 when we consider only velocity feedforward 
switch_gain=5e-2;%Cost function gains Switch_gain and cross_gain
cross_gain=5e-2;

%%
run('parameter_project')
sim('digiex3')
run('plotting_project')
