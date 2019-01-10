% Flow parameters
PA.flow=45/6e4;
AT.flow=25/6e4;

%%%%%Cylinder Parameters::
Cyl.D=32e-3;
Cyl.d=18e-3;
Cyl.area=(pi/4)*(Cyl.D^2);
Cyl.x_max=400e-3;
Cyl.B=1100e6;
Cyl.pA_init = 6e6;
Cyl.pB_init = 8e6;


%%%%%Port orifice
Kv=2.5e-7;
ptr=1e5;
dpn=2e6;
%%%%%%%PRESSURE VALVES
 Supply.p=9e6;
 Tank.p=0;

%Friction parameters
Load.m=55;
Fric.b = 1600; % Cylinder viscous friction [Ns/m]
Fric.Fc = 300; % Cylinder Coulomb’s friction [N]
Fric.Fs = 600; % Static friction [N] 
Fric.vtol = 0.005; % Velocity for minimum friction
Fric.m_est = Load.m; % Load mass estimate 
Fric.preslide = 0.2e-3; % Bending of the seal
Cyl.End_K = 1e7; 




%EQ: ones(1,(N+1)^2); 
response.time=20e-3;
Controller.ts=25e-3;
Qn=45/6e4;

Valve.Kv=(1.1*(Qn/(2^N-1)/sqrt(dpn))*2.^(0:N-1));


%control_mtrx=fliplr(double((dec2bin(0:2^(2*N)-1))=='1'));


%%%%%%%DFCU AT &PA Parameters:
Qn_at=25/6e4;
Qn_pa=45/6e4;
Kv_unit_PA =PA.flow/sqrt(2e6);   %1.35e-08; %Initial value – tune later 
Kv_unit_AT =AT.flow/sqrt(2e6); %1.08e-08; %Initial value – tune later 
DFCU.PA_Kv = (Qn_pa/(2^N-1)/sqrt(dpn))*2.^(0:N-1); 
DFCU.AT_Kv = (Qn_at/(2^N-1)/sqrt(dpn))*2.^(0:N-1);
rng(267602);
DFCU_PA_REAL=DFCU.PA_Kv.*(1+0.2*(rand(1,N)-0.5));% changing the flow coefficient randamly to make it more realistic
DFCU_AT_REAL=DFCU.AT_Kv.*(1+0.2*(rand(1,N)-0.5));


%%%%%%%Valve Dynamics:
Valve.switch_o_delay = 12e-3*ones(1,N); 
Valve.switch_c_delay = 12e-3*ones(1,N); 
Valve.switch_o_time = 3e-3; 
Valve.switch_c_time = 3e-3;


%%%%%%%
Cyl.x_init=50e-3;
t_values=[1 2 3 5 6 7 8 9]*1.5;
x_values=[0 0.075 0.075 0 0 0.3 0.3 0 0]+Cyl.x_init;
dt_values=[1 1 1 1 1 1 1 1]*1.5;
ts=0.01;
poly_degree=5;
[t_ref,x_ref,v_ref] = poly_traj_iha2576(t_values,dt_values,x_values,ts,poly_degree);

%%Equal coding

% Coding = 'binary'; %Coding: type string: ‘binary’ or ‘equal’ 
switch Coding 
   case 'binary' 
         
         DFCU.PA_Kv = (Qn_pa/(2^N-1)/sqrt(dpn))*2.^(0:N-1); 
         DFCU.AT_Kv = (Qn_at/(2^N-1)/sqrt(dpn))*2.^(0:N-1);
         DFCU_PA_REAL = DFCU.PA_Kv.*(1+0.2*(rand(1,N)-0.5));% changing the flow coefficient randamly to make it more realistic
         DFCU_AT_REAL = DFCU.AT_Kv.*(1+0.2*(rand(1,N)-0.5));
         PA_gain= 1*2.^(0:N-1);
         AT_gain=1*2.^(0:N-1);
         ctrl_mtrx = fliplr(double((dec2bin(0:2^N-1))=='1'));
         ctrl_mtrx2=combvec(ctrl_mtrx',ctrl_mtrx')'; %for sum flow controller using binary coding
         DFCU.one=ones(1,size(ctrl_mtrx2,1));
 
   case 'equal' 
        DFCU.one=ones(1,(N+1)^2);
        DFCU.PA_Kv = ones(1,N)*((Qn_pa/sqrt(dpn))/N);
        DFCU.PA_Kv = ones(1,N)*((Qn_pa/sqrt(dpn))/N);
        DFCU_PA_REAL = DFCU.PA_Kv.*(1+0.2*(rand(1,N)-0.5));% changing the flow coefficient randamly to make it more realistic
        DFCU_AT_REAL = DFCU.AT_Kv.*(1+0.2*(rand(1,N)-0.5));
        PA_gain=ones(1,N);
        AT_gain=ones(1,N);
        ctrl_mtrx =tril(ones(N+1,N),-1); %for single DFCU 
        ctrl_mtrx2=combvec(ctrl_mtrx',ctrl_mtrx')'; %for sum flow controller using equal coding
        DFCU.one=ones(1,size(ctrl_mtrx2,1));
end 


