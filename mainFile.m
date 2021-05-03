clc;
clear;
close all;
%% Forward kinematics
robot = importrobot('NUgus.urdf');
robot.DataFormat = 'column';
%% Params
param = gaitParameters(robot);
% %% Trajectory Plan CoM -> left support
% param.supportFoot = 'left_foot';
% param.swingFoot = 'right_foot';
% com_trajectory = generateCoMTrajectory(param);
% %% Inverse Kinematics - CoM -> left support
% [opt_joint_angles_1] = inverseKinematicsCoM(robot,com_trajectory,param)
%% Trajectory Plan Half Step
param.supportFoot = 'left_foot';
param.swingFoot = 'right_foot';
% param.initialConditions = opt_joint_angles_1(:,end);
isHalfStep = true;
trajectory_1 = generateFootTrajectory(param,isHalfStep);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_1] = inverseKinematics(robot,trajectory_1,param);
% %% Trajectory Plan CoM -> right support
% param.supportFoot = 'right_foot';
% param.swingFoot = 'left_foot';
% param.initialConditions = opt_joint_angles_2(:,end);
% com_trajectory = generateCoMTrajectory(param);
% %% Inverse Kinematics - CoM -> left support
% [opt_joint_angles_3] = inverseKinematicsCoM(robot,com_trajectory,param)
%% Trajectory Plan Full Step
param.supportFoot = 'right_foot';
param.swingFoot = 'left_foot';
isHalfStep = false;
param.initialConditions = opt_joint_angles_1(:,end);
trajectory_2 = generateFootTrajectory(param,isHalfStep);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_2] = inverseKinematics(robot,trajectory_2,param);
%% Trajectory Plan Full Step
param.supportFoot = 'left_foot';
param.swingFoot = 'right_foot';
isHalfStep = false;
param.initialConditions = opt_joint_angles_2(:,end);
trajectory_3 = generateFootTrajectory(param,isHalfStep);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_3] = inverseKinematics(robot,trajectory_3,param);
%% Plot first step
param.supportFoot = 'left_foot';
param.swingFoot = 'right_foot';
plot3DRobot(opt_joint_angles_1,robot,param,trajectory_1);
%% Plot 2nd step
param.supportFoot = 'right_foot';
param.swingFoot = 'left_foot';
plot3DRobot(opt_joint_angles_2,robot,param,trajectory_2);
%% Plot 3rd step
param.supportFoot = 'left_foot';
param.swingFoot = 'right_foot';
plot3DRobot(opt_joint_angles_3,robot,param,trajectory_3);
%% Pack servo positions
servo_positions = [opt_joint_angles_1,opt_joint_angles_2,opt_joint_angles_3,opt_joint_angles_2,opt_joint_angles_3,opt_joint_angles_2,opt_joint_angles_3];