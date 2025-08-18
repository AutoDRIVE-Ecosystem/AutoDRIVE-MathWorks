classdef rzr < handle
    % AutoDRIVE RZR MATLAB API
    % Attributes and methods to store and parse RZR data and commands

    properties
        % RZR data
        id = uint16(1);
        collision_count = uint16(1);
        throttle = double(0.0);
        steering = double(0.0);
        brake = double(0.0);
        handbrake = double(0.0);
        encoder_ticks = int32([0; 0]);
        encoder_angles = double([0; 0]);
        position = double([0; 0; 0]);
        orientation_quaternion = double([0; 0; 0; 0]);
        orientation_euler_angles = double([0; 0; 0]);
        angular_velocity = double([0; 0; 0]);
        linear_acceleration = double([0; 0; 0]);
        % lidar_pointcloud = single(zeros(57600,3));
        left_camera_image = uint8(zeros(720,1280,3));
        right_camera_image = uint8(zeros(720,1280,3));
        % RZR commands
        cosim_mode = 0;
        posX_command = 0;
        posY_command = 0;
        posZ_command = 0;
        rotX_command = 0;
        rotY_command = 0;
        rotZ_command = 0;
        rotW_command = 0;
        throttle_command = 0;
        steering_command = 0;
        brake_command = 0;
        handbrake_command = 0;
        headlights_command = uint8(1);
        % Environment commands
        env = environment;
    end

    methods
        function parse_data(obj,data)
            % Collision count
            obj.collision_count = uint16(str2double(data.V1Collisions));
            % Actuator feedbacks
            obj.throttle = str2double(data.V1Throttle);
            obj.steering = str2double(data.V1Steering);
            obj.brake = str2double(data.V1Brake);
            obj.handbrake = str2double(data.V1Handbrake);
            % Wheel encoders
            obj.encoder_ticks = cell2mat(textscan(data.V1EncoderTicks,'%d'));
            obj.encoder_angles = cell2mat(textscan(data.V1EncoderAngles,'%f'));
            % IPS
            obj.position = cell2mat(textscan(data.V1Position,'%f'));
            % IMU
            obj.orientation_quaternion = cell2mat(textscan(data.V1OrientationQuaternion,'%f'));
            obj.orientation_euler_angles = cell2mat(textscan(data.V1OrientationEulerAngles,'%f'));
            obj.angular_velocity = cell2mat(textscan(data.V1AngularVelocity,'%f'));
            obj.linear_acceleration = cell2mat(textscan(data.V1LinearAcceleration,'%f'));
            % LIDAR
            % raw_lidar_pointcloud = matlab.net.base64decode(data.V1LIDARPointcloud); % Raw byte array
            % numericValues = typecast(uint8(raw_lidar_pointcloud), 'single'); % Convert to numeric values
            % numPoints = numel(numericValues) / 3; % Get number of points
            % obj.lidar_pointcloud = reshape(numericValues, 3, numPoints)'; % Reshape into 3-column matrix
            % Cameras
            obj.left_camera_image = matlab.net.base64decode(data.V1LeftCameraImage);
            obj.left_camera_image = javax.imageio.ImageIO.read(java.io.ByteArrayInputStream(obj.left_camera_image));
            obj.left_camera_image = reshape(typecast(obj.left_camera_image.getData.getDataStorage, 'uint8'), [3,1280,720]);
            obj.left_camera_image = cat(3,transpose(reshape(obj.left_camera_image(3,:,:), [1280,720])), ...
                                           transpose(reshape(obj.left_camera_image(2,:,:), [1280,720])), ...
                                           transpose(reshape(obj.left_camera_image(1,:,:), [1280,720])));
            obj.right_camera_image = matlab.net.base64decode(data.V1RightCameraImage);
            obj.right_camera_image = javax.imageio.ImageIO.read(java.io.ByteArrayInputStream(obj.right_camera_image));
            obj.right_camera_image = reshape(typecast(obj.right_camera_image.getData.getDataStorage, 'uint8'), [3,1280,720]);
            obj.right_camera_image = cat(3,transpose(reshape(obj.right_camera_image(3,:,:), [1280,720])), ...
                                          transpose(reshape(obj.right_camera_image(2,:,:), [1280,720])), ...
                                          transpose(reshape(obj.right_camera_image(1,:,:), [1280,720])));
        end

        function data = generate_commands(obj)
            data = obj.env.generate_commands();
            data = strcat('42["Bridge",{"V1 CoSim":"',num2str(obj.cosim_mode), ...
                          '","V1 PosX":"',num2str(obj.posX_command), ...
                          '","V1 PosY":"',num2str(obj.posY_command), ...
                          '","V1 PosZ":"',num2str(obj.posZ_command), ...
                          '","V1 RotX":"',num2str(obj.rotX_command), ...
                          '","V1 RotY":"',num2str(obj.rotY_command), ...
                          '","V1 RotZ":"',num2str(obj.rotZ_command), ...
                          '","V1 RotW":"',num2str(obj.rotW_command), ...
                          '","V1 Throttle":"',num2str(obj.throttle_command), ...
                          '","V1 Steering":"',num2str(obj.steering_command), ...
                          '","V1 Brake":"',num2str(obj.brake_command), ...
                          '","V1 Handbrake":"',num2str(obj.handbrake_command), ...
                          '","V1 Headlights":"',num2str(obj.headlights_command), ...
                          data,'"}]');
        end
    end
end