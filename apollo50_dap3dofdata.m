% aero_dap3dofdata - Initialize aero_dap3dof model parameters for the
% mission phase "Descent Orbit Insertion trajectory (Engine cutoff)". See
% aero_dap3dofsetup.mlx for more information about the mission segment.

% Copyright 2012-2019 The MathWorks, Inc.

t_rangeZero             = datetime(1969,7,16,13,32,0); % lift-off
t_descentInsertionStart = t_rangeZero + hours(101) + minutes(36) + seconds(14);
t_descentInsertion      = t_descentInsertionStart + seconds(30); % 30 sec burn

% Initial Vehicle State
t_start   = juliandate(t_descentInsertion); % Sim start date (Julian date)
t_runtime = 120; % (run for first 2 minutes) [s]
lla_0     = [-1.16, -141.88, convlength(57.8, 'naut mi', 'ft')]; % Estimated LM position at t_start [deg, deg, ft]
vel       = [0 5284.9 0]'; % Initial vehicle velocity [ft/s]
euler_0   = [-30 -10 -60]; % Initial attitude [deg]
vel_0     = angle2dcm(euler_0(3)*pi/180, euler_0(2)*pi/180, euler_0(1)*pi/180, 'ZYX')*vel;

% Vehicle Properties
I1=10000; I2=100000; I3=110000;
Inertia_0 = diag([I2,I3,I1],0); % Inertia tensor [slug*ft^2]
mass_0    = 33296; % Mass [lb]

% RCS Properties
Force  = 100; % RCS jet Force (lbf)
L_arm  = 5.5; % RCS Jet moment arm [ft]
DB     = 0.345*pi/180; % Deadband [rad/s^2]
tmin   = 0.014; % Minimum impulse firing time [s]
alph1  = Force*L_arm/I1; % Yaw axis single jet accel [rad/s^2]
alph2  = Force*L_arm*sqrt(2)/2/I2; % Pitch axis single jet accel [rad/s^2]
alph3  = Force*L_arm/I3; % Roll axis single jet accel [rad/s^2]
alphu  = [sqrt(2) sqrt(2)]/2*[alph2 alph3]'; % U axis single jet accel [rad/s^2] 
alphv  = [-sqrt(2) sqrt(2)]/2*[alph2 alph3]'; % V axis single jet accel [rad/s^2]
alphs1 = 0.1*alph1; % Yaw axis single jet switch curve accel [rad/s^2]
alphsu = 0.1*alphu; % U axis single jet switch curve accel [rad/s^2]
alphsv = 0.1*alphv; % V axis single jet switch curve accel [rad/s^2]

% RCS Control Clocks
clockt = 1/200; % rcs counter [s]
delt   = .1; % rcs sample time [s]

% Moon Planetary Properties: 
r_moon_eq  = 5702428; % Moon equatorial radius [ft]
f_moon     = .0012; % Moon flattening
omega_moon = 2.7e-6; % Moon rotational rate [rad/s]