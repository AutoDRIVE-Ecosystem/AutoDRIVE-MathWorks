function autodrive_rzr(block)
% AutoDRIVE RZR Simulink API
% This is a Level-2 MATLAB S-Function wrapper for AutoDRIVE RZR API

% Copyright 2024 AutoDRIVE Ecosystem

%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.

setup(block);

%endfunction

%% Function: setup
%% Abstract:
%% Set up the basic characteristics of the S-function block such as:
%% - Input ports
%% - Output ports
%% - Dialog parameters
%% - Options
%%
%% Required: Yes
%% C MEX counterpart: mdlInitializeSizes

function setup(block)

% Allow more than 2D signals
block.AllowSignalsWithMoreThan2D = 1;

% Register number of ports
block.NumInputPorts = 21;
block.NumOutputPorts = 15;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
% Co-Simulation Mode
block.InputPort(1).Dimensions = 1;
block.InputPort(1).DatatypeID = 3; % uint8
block.InputPort(1).Complexity = 'Real';
block.InputPort(1).DirectFeedthrough = true;
% Position X Component
block.InputPort(2).Dimensions = 1;
block.InputPort(2).DatatypeID = 0; % double
block.InputPort(2).Complexity = 'Real';
block.InputPort(2).DirectFeedthrough = true;
% Position Y Component
block.InputPort(3).Dimensions = 1;
block.InputPort(3).DatatypeID = 0; % double
block.InputPort(3).Complexity = 'Real';
block.InputPort(3).DirectFeedthrough = true;
% Position Z Component
block.InputPort(4).Dimensions = 1;
block.InputPort(4).DatatypeID = 0; % double
block.InputPort(4).Complexity = 'Real';
block.InputPort(4).DirectFeedthrough = true;
% Orientation Quaternion X Component
block.InputPort(5).Dimensions = 1;
block.InputPort(5).DatatypeID = 0; % double
block.InputPort(5).Complexity = 'Real';
block.InputPort(5).DirectFeedthrough = true;
% Orientation Quaternion Y Component
block.InputPort(6).Dimensions = 1;
block.InputPort(6).DatatypeID = 0; % double
block.InputPort(6).Complexity = 'Real';
block.InputPort(6).DirectFeedthrough = true;
% Orientation Quaternion Z Component
block.InputPort(7).Dimensions = 1;
block.InputPort(7).DatatypeID = 0; % double
block.InputPort(7).Complexity = 'Real';
block.InputPort(7).DirectFeedthrough = true;
% Orientation Quaternion W Component
block.InputPort(8).Dimensions = 1;
block.InputPort(8).DatatypeID = 0; % double
block.InputPort(8).Complexity = 'Real';
block.InputPort(8).DirectFeedthrough = true;
% Throttle Command
block.InputPort(9).Dimensions = 1;
block.InputPort(9).DatatypeID = 0; % double
block.InputPort(9).Complexity = 'Real';
block.InputPort(9).DirectFeedthrough = true;
% Steering Command
block.InputPort(10).Dimensions = 1;
block.InputPort(10).DatatypeID = 0; % double
block.InputPort(10).Complexity = 'Real';
block.InputPort(10).DirectFeedthrough = true;
% Brake Command
block.InputPort(11).Dimensions = 1;
block.InputPort(11).DatatypeID = 0; % double
block.InputPort(11).Complexity = 'Real';
block.InputPort(11).DirectFeedthrough = true;
% Handbrake Command
block.InputPort(12).Dimensions = 1;
block.InputPort(12).DatatypeID = 0; % double
block.InputPort(12).Complexity = 'Real';
block.InputPort(12).DirectFeedthrough = true;
% Headlights Command
block.InputPort(13).Dimensions = 1;
block.InputPort(13).DatatypeID = 3; % uint8
block.InputPort(13).Complexity = 'Real';
block.InputPort(13).DirectFeedthrough = true;
% Auto-Time Command
block.InputPort(14).Dimensions = 1;
block.InputPort(14).DatatypeID = 8; % boolean
block.InputPort(14).Complexity = 'Real';
block.InputPort(14).DirectFeedthrough = true;
% Time Scale Command
block.InputPort(15).Dimensions = 1;
block.InputPort(15).DatatypeID = 0; % double
block.InputPort(15).Complexity = 'Real';
block.InputPort(15).DirectFeedthrough = true;
% Time of Day Command
block.InputPort(16).Dimensions = 1;
block.InputPort(16).DatatypeID = 0; % double
block.InputPort(16).Complexity = 'Real';
block.InputPort(16).DirectFeedthrough = true;
% Weather ID Command
block.InputPort(17).Dimensions = 1;
block.InputPort(17).DatatypeID = 3; % uint8
block.InputPort(17).Complexity = 'Real';
block.InputPort(17).DirectFeedthrough = true;
% Cloud Intensity Command
block.InputPort(18).Dimensions = 1;
block.InputPort(18).DatatypeID = 0; % double
block.InputPort(18).Complexity = 'Real';
block.InputPort(18).DirectFeedthrough = true;
% Fog Intensity Command
block.InputPort(19).Dimensions = 1;
block.InputPort(19).DatatypeID = 0; % double
block.InputPort(19).Complexity = 'Real';
block.InputPort(19).DirectFeedthrough = true;
% Rain Intensity Command
block.InputPort(20).Dimensions = 1;
block.InputPort(20).DatatypeID = 0; % double
block.InputPort(20).Complexity = 'Real';
block.InputPort(20).DirectFeedthrough = true;
% Snow Intensity Command
block.InputPort(21).Dimensions = 1;
block.InputPort(21).DatatypeID = 0; % double
block.InputPort(21).Complexity = 'Real';
block.InputPort(21).DirectFeedthrough = true;

% Override output port properties
% Vehicle ID
block.OutputPort(1).Dimensions = 1;
block.OutputPort(1).DatatypeID = 5; % uint16
block.OutputPort(1).Complexity = 'Real';
% Collision Count
block.OutputPort(2).Dimensions = 1;
block.OutputPort(2).DatatypeID = 5; % uint16
block.OutputPort(2).Complexity = 'Real';
% Throttle Feedback
block.OutputPort(3).Dimensions = 1;
block.OutputPort(3).DatatypeID = 0; % double
block.OutputPort(3).Complexity = 'Real';
% Steering Feedback
block.OutputPort(4).Dimensions = 1;
block.OutputPort(4).DatatypeID = 0; % double
block.OutputPort(4).Complexity = 'Real';
% Brake Feedback
block.OutputPort(5).Dimensions = 1;
block.OutputPort(5).DatatypeID = 0; % double
block.OutputPort(5).Complexity = 'Real';
% Handbrake Feedback
block.OutputPort(6).Dimensions = 1;
block.OutputPort(6).DatatypeID = 0; % double
block.OutputPort(6).Complexity = 'Real';
% Encoder Ticks
block.OutputPort(7).Dimensions = [2 1];
block.OutputPort(7).DatatypeID = 6; % int32
block.OutputPort(7).Complexity = 'Real';
% Encoder Angles
block.OutputPort(8).Dimensions = [2 1];
block.OutputPort(8).DatatypeID = 0; % double
block.OutputPort(8).Complexity = 'Real';
% Position
block.OutputPort(9).Dimensions = [3 1];
block.OutputPort(9).DatatypeID = 0; % double
block.OutputPort(9).Complexity = 'Real';
% Orientation (Quaternion)
block.OutputPort(10).Dimensions = [4 1];
block.OutputPort(10).DatatypeID = 0; % double
block.OutputPort(10).Complexity = 'Real';
% Orientation (Euler Angles)
block.OutputPort(11).Dimensions = [3 1];
block.OutputPort(11).DatatypeID = 0; % double
block.OutputPort(11).Complexity = 'Real';
% Angular Velocity
block.OutputPort(12).Dimensions = [3 1];
block.OutputPort(12).DatatypeID = 0; % double
block.OutputPort(12).Complexity = 'Real';
% Linear Acceleration
block.OutputPort(13).Dimensions = [3 1];
block.OutputPort(13).DatatypeID = 0; % double
block.OutputPort(13).Complexity = 'Real';
% LIDAR Pointcloud
% block.OutputPort(14).DimensionsMode = 'Variable';
% block.OutputPort(14).Dimensions = [57600,3]; % max. size
% block.OutputPort(14).DatatypeID = 1; % single
% block.OutputPort(14).Complexity = 'Real';
% Camera 01
block.OutputPort(14).Dimensions = [720,1280,3];
block.OutputPort(14).DatatypeID = 3; % uint8
block.OutputPort(14).Complexity = 'Real';
% Camera 02
block.OutputPort(15).Dimensions = [720,1280,3];
block.OutputPort(15).DatatypeID = 3; % uint8
block.OutputPort(15).Complexity = 'Real';

% Register parameters
block.NumDialogPrms = 1;

% Register sample times
% [0 offset] : Continuous sample time
% [positive_num offset] : Discrete sample time
% [-1, 0] : Inherited sample time
% [-2, 0] : Variable sample time
block.SampleTimes = [1 0];

% Specify the block simStateCompliance. The allowed values are:
% 'UnknownSimState', < The default setting; warn and assume DefaultSimState
% 'DefaultSimState', < Same sim state as a built-in block
% 'HasNoSimState', < No sim state
% 'CustomSimState', < Has GetSimState and SetSimState methods
% 'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.

% block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
% block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs); % Required
% block.RegBlockMethod('Update', @Update);
% block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

%% PostPropagationSetup:
%% Functionality: Setup work areas and state variables. Can
%% also register run-time methods here
%% Required: No
%% C MEX counterpart: mdlSetWorkWidths

% function DoPostPropSetup(block)

%end DoPostPropSetup(block)

%% InitializeConditions:
%% Functionality: Called at the start of simulation and if it is 
%% present in an enabled subsystem configured to reset 
%% states, it will be called when the enabled subsystem
%% restarts execution to reset the states.
%% Required: No
%% C MEX counterpart: mdlInitializeConditions

function InitializeConditions(block)
global autodrive
autodrive = server_rzr(block.DialogPrm(1).Data);
autodrive.rzr_1.collision_count = uint16(0);
block.OutputPort(2).Data = uint16(0);
system('start /B "AutoDRIVE" "Simulator\AutoDRIVE Simulator.exe"');

%end InitializeConditions

%% Start:
%% Functionality: Called once at start of model execution. If you
%% have states that should be initialized once, this 
%% is the place to do it.
%% Required: No
%% C MEX counterpart: mdlStart

% function Start(block)

%end Start

%% Outputs:
%% Functionality: Called to generate block outputs in
%% simulation step
%% Required: Yes
%% C MEX counterpart: mdlOutputs

function Outputs(block)
global autodrive
% Parse inputs
autodrive.rzr_1.cosim_mode = block.InputPort(1).Data;
autodrive.rzr_1.posX_command = block.InputPort(2).Data;
autodrive.rzr_1.posY_command = block.InputPort(3).Data;
autodrive.rzr_1.posZ_command = block.InputPort(4).Data;
autodrive.rzr_1.rotX_command = block.InputPort(5).Data;
autodrive.rzr_1.rotY_command = block.InputPort(6).Data;
autodrive.rzr_1.rotZ_command = block.InputPort(7).Data;
autodrive.rzr_1.rotW_command = block.InputPort(8).Data;
autodrive.rzr_1.throttle_command = block.InputPort(9).Data;
autodrive.rzr_1.steering_command = block.InputPort(10).Data;
autodrive.rzr_1.brake_command = block.InputPort(11).Data;
autodrive.rzr_1.handbrake_command = block.InputPort(12).Data;
autodrive.rzr_1.headlights_command = block.InputPort(13).Data;
autodrive.rzr_1.env.auto_time = block.InputPort(14).Data;
autodrive.rzr_1.env.time_scale = block.InputPort(15).Data;
autodrive.rzr_1.env.time_of_day = block.InputPort(16).Data;
autodrive.rzr_1.env.weather_id = block.InputPort(17).Data;
autodrive.rzr_1.env.cloud_intensity = block.InputPort(18).Data;
autodrive.rzr_1.env.fog_intensity = block.InputPort(19).Data;
autodrive.rzr_1.env.rain_intensity = block.InputPort(20).Data;
autodrive.rzr_1.env.snow_intensity = block.InputPort(21).Data;
% Configure outputs
block.OutputPort(1).Data = autodrive.rzr_1.id;
block.OutputPort(2).Data = autodrive.rzr_1.collision_count;
block.OutputPort(3).Data = autodrive.rzr_1.throttle;
block.OutputPort(4).Data = autodrive.rzr_1.steering;
block.OutputPort(5).Data = autodrive.rzr_1.brake;
block.OutputPort(6).Data = autodrive.rzr_1.handbrake;
block.OutputPort(7).Data = autodrive.rzr_1.encoder_ticks;
block.OutputPort(8).Data = autodrive.rzr_1.encoder_angles;
block.OutputPort(9).Data = autodrive.rzr_1.position;
block.OutputPort(10).Data = autodrive.rzr_1.orientation_quaternion;
block.OutputPort(12).Data = autodrive.rzr_1.orientation_euler_angles;
block.OutputPort(12).Data = autodrive.rzr_1.angular_velocity;
block.OutputPort(13).Data = autodrive.rzr_1.linear_acceleration;
% block.OutputPort(14).CurrentDimensions = [size(autodrive.rzr_1.lidar_pointcloud,1),3];
% block.OutputPort(14).Data = autodrive.rzr_1.lidar_pointcloud;
block.OutputPort(14).Data = autodrive.rzr_1.left_camera_image;
block.OutputPort(15).Data = autodrive.rzr_1.right_camera_image;

%end Outputs

%% Update:
%% Functionality: Called to update discrete states
%% during simulation step
%% Required: No
%% C MEX counterpart: mdlUpdate

% function Update(block)

%end Update

%% Derivatives:
%% Functionality: Called to update derivatives of
%% continuous states during simulation step
%% Required: No
%% C MEX counterpart: mdlDerivatives

% function Derivatives(block)

%end Derivatives

%% Terminate:
%% Functionality: Called at the end of simulation for cleanup
%% Required: Yes
%% C MEX counterpart: mdlTerminate

function Terminate(block)
global autodrive
autodrive.rzr_1.collision_count = uint16(0);
block.OutputPort(2).Data = uint16(0);
autodrive.stop;
autodrive.delete;
system('taskkill /F /IM "AutoDRIVE Simulator.exe"');

%end Terminate