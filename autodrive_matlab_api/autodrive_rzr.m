classdef autodrive_rzr < handle
    % AutoDRIVE RZR API
    % Attributes and methods to store and parse RZR data and commands

    properties
        % RZR data
        id;
        collision_count;
        throttle;
        steering;
        brake;
        handbrake;
        encoder_ticks;
        encoder_angles;
        position;
        orientation_quaternion;
        orientation_euler_angles;
        angular_velocity;
        linear_acceleration;
        % lidar_pointcloud;
        left_camera_image;
        right_camera_image;
        % RZR commands
        cosim_mode;
        posX_command;
        posY_command;
        posZ_command;
        rotX_command;
        rotY_command;
        rotZ_command;
        rotW_command;
        throttle_command;
        steering_command;
        brake_command;
        handbrake_command;
        headlights_command;
        % Environment commands
        env = autodrive_environment;
    end

    methods
        function parse_data(obj,data,leftcamera_ax,rightcamera_ax,verbose)
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
            % obj.lidar_pointcloud = matlab.net.base64decode(data.V1LIDARPointcloud);
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
            if verbose
                fprintf('\n--------------------------------\n')
                fprintf('Receive Data from RZR:\n')
                fprintf('--------------------------------\n\n')
                % Monitor RZR data
                fprintf('Collisions: %f\n',obj.collision_count)
                fprintf('Throttle: %f\n',obj.throttle)
                fprintf('Steering: %f\n',obj.steering)
                fprintf('Brake: %f\n',obj.brake)
                fprintf('Handbrake: %f\n',obj.handbrake)
                fprintf('Encoder Ticks: [%d %d]\n',obj.encoder_ticks(1),obj.encoder_ticks(2))
                fprintf('Encoder Angles: [%d %d]\n',obj.encoder_angles(1),obj.encoder_angles(2))
                fprintf('Position: [%f %f %f]\n',obj.position(1),obj.position(2),obj.position(3))
                fprintf('Orientation [Quaternion]: [%f %f %f %f]\n',obj.orientation_quaternion(1),obj.orientation_quaternion(2),obj.orientation_quaternion(3),obj.orientation_quaternion(4))
                fprintf('Orientation [Euler Angles]: [%f %f %f]\n',obj.orientation_euler_angles(1),obj.orientation_euler_angles(2),obj.orientation_euler_angles(3))
                fprintf('Angular Velocity: [%f %f %f]\n',obj.angular_velocity(1),obj.angular_velocity(2),obj.angular_velocity(3))
                fprintf('Linear Acceleration: [%f %f %f]\n',obj.linear_acceleration(1),obj.linear_acceleration(2),obj.linear_acceleration(3))
                % Visualize camera frames
                % Left camera
                imshow(imresize(obj.left_camera_image, 0.5),'Parent',leftcamera_ax);
                drawnow;
                % Right camera
                imshow(imresize(obj.right_camera_image, 0.5),'Parent',rightcamera_ax);
                drawnow;
                % Visualize LIDAR pointcloud
                % % Convert the byte array to numeric values
                % numericValues = typecast(uint8(obj.lidar_pointcloud), 'single');
                % % Reshape the numeric values into a 3-column matrix (assuming each point has x, y, and z coordinates)
                % numPoints = numel(numericValues) / 3;
                % pointCloud = reshape(numericValues, 3, numPoints)';                
                % % Extract x, y, and z coordinates
                % x = pointCloud(:, 1);
                % y = pointCloud(:, 2);
                % z = pointCloud(:, 3);
                % % Plot pointcloud
                % colormap jet
                % scatter3(x, y, z, 1, z, 'filled','Parent',pointcloud_ax);
                % xlabel('X');
                % ylabel('Y');
                % zlabel('Z');
                % title('LIDAR Pointcloud');
                % colorbar;
                % axis equal;
                % drawnow;
            end
        end

        function data = generate_commands(obj,verbose)
            if verbose
                fprintf('\n--------------------------------\n')
                fprintf('Transmit Data to RZR:\n')
                fprintf('--------------------------------\n\n')
                % Monitor RZR control commands
                if obj.cosim_mode == 0
                    cosim_mode_str = 'False';
                else
                    cosim_mode_str = 'True';
                end
                fprintf('Co-Simulation Mode: %s\n',cosim_mode_str)
                fprintf('Position Command: [%d %d %d]\n',obj.posX_command, obj.posY_command, obj.posZ_command)
                fprintf('Rotation Command: [%d %d %d %d]\n',obj.rotX_command, obj.rotY_command, obj.rotZ_command, obj.rotW_command)
                fprintf('Throttle Command: %d\n',obj.throttle_command)
                fprintf('Steering Command: %d\n',obj.steering_command)
                fprintf('Brake Command: %d\n',obj.brake_command)
                fprintf('Handbrake Command: %d\n',obj.handbrake_command)
                fprintf('Headlights Command: %d\n',obj.headlights_command)
            end
            data = obj.env.generate_commands(true);
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