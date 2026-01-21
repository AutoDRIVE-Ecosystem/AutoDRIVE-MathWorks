classdef autodrive_hunter < handle
    % AutoDRIVE Hunter SE API
    % Attributes and methods to store and parse Hunter SE data and commands

    properties
        % Hunter SE data
        id;
        throttle;
        steering;
        encoder_ticks;
        encoder_angles;
        position;
        orientation_quaternion;
        orientation_euler_angles;
        angular_velocity;
        linear_acceleration;
        lidar_pointcloud;
        front_camera_image;
        rear_camera_image;
        % Hunter SE commands
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
    end

    methods
        function parse_data(obj,data,frontcamera_ax,rearcamera_ax,pointcloud_ax,verbose)
            % Actuator feedbacks
            obj.throttle = str2double(data.V1Throttle);
            obj.steering = str2double(data.V1Steering);
            % Wheel encoders
            obj.encoder_ticks = cell2mat(textscan(data.V1EncoderTicks,'%d'));
            obj.encoder_angles = cell2mat(textscan(data.V1EncoderAngles,'%d'));
            % IPS
            obj.position = cell2mat(textscan(data.V1Position,'%f'));
            % IMU
            obj.orientation_quaternion = cell2mat(textscan(data.V1OrientationQuaternion,'%f'));
            obj.orientation_euler_angles = cell2mat(textscan(data.V1OrientationEulerAngles,'%f'));
            obj.angular_velocity = cell2mat(textscan(data.V1AngularVelocity,'%f'));
            obj.linear_acceleration = cell2mat(textscan(data.V1LinearAcceleration,'%f'));
            % LIDAR
            obj.lidar_pointcloud = matlab.net.base64decode(data.V1LIDARPointcloud);
            % Cameras
            obj.front_camera_image = matlab.net.base64decode(data.V1FrontCameraImage);
            obj.front_camera_image = javax.imageio.ImageIO.read(java.io.ByteArrayInputStream(obj.front_camera_image));
            obj.front_camera_image = reshape(typecast(obj.front_camera_image.getData.getDataStorage, 'uint8'), [3,1280,720]);
            obj.front_camera_image = cat(3,transpose(reshape(obj.front_camera_image(3,:,:), [1280,720])), ...
                                           transpose(reshape(obj.front_camera_image(2,:,:), [1280,720])), ...
                                           transpose(reshape(obj.front_camera_image(1,:,:), [1280,720])));
            obj.rear_camera_image = matlab.net.base64decode(data.V1RearCameraImage);
            obj.rear_camera_image = javax.imageio.ImageIO.read(java.io.ByteArrayInputStream(obj.rear_camera_image));
            obj.rear_camera_image = reshape(typecast(obj.rear_camera_image.getData.getDataStorage, 'uint8'), [3,1280,720]);
            obj.rear_camera_image = cat(3,transpose(reshape(obj.rear_camera_image(3,:,:), [1280,720])), ...
                                          transpose(reshape(obj.rear_camera_image(2,:,:), [1280,720])), ...
                                          transpose(reshape(obj.rear_camera_image(1,:,:), [1280,720])));
            if verbose
                fprintf('\n--------------------------------\n')
                fprintf('Receive Data from Hunter SE:\n')
                fprintf('--------------------------------\n\n')
                % Monitor Hunter SE data
                fprintf('Throttle: %f\n',obj.throttle)
                fprintf('Steering: %f\n',obj.steering)
                fprintf('Encoder Ticks: [%d %d]\n',obj.encoder_ticks(1),obj.encoder_ticks(2))
                fprintf('Encoder Angles: [%d %d]\n',obj.encoder_angles(1),obj.encoder_angles(2))
                fprintf('Position: [%f %f %f]\n',obj.position(1),obj.position(2),obj.position(3))
                fprintf('Orientation [Quaternion]: [%f %f %f %f]\n',obj.orientation_quaternion(1),obj.orientation_quaternion(2),obj.orientation_quaternion(3),obj.orientation_quaternion(4))
                fprintf('Orientation [Euler Angles]: [%f %f %f]\n',obj.orientation_euler_angles(1),obj.orientation_euler_angles(2),obj.orientation_euler_angles(3))
                fprintf('Angular Velocity: [%f %f %f]\n',obj.angular_velocity(1),obj.angular_velocity(2),obj.angular_velocity(3))
                fprintf('Linear Acceleration: [%f %f %f]\n',obj.linear_acceleration(1),obj.linear_acceleration(2),obj.linear_acceleration(3))
                % Visualize camera frames
                % Front camera
                imshow(imresize(obj.front_camera_image, 0.5),'Parent',frontcamera_ax);
                drawnow;
                % Rear camera
                imshow(imresize(obj.rear_camera_image, 0.5),'Parent',rearcamera_ax);
                drawnow;
                % Visualize LIDAR pointcloud
                % Convert the byte array to numeric values
                numericValues = typecast(uint8(obj.lidar_pointcloud), 'single');
                % Reshape the numeric values into a 3-column matrix (assuming each point has x, y, and z coordinates)
                numPoints = numel(numericValues) / 3;
                pointCloud = reshape(numericValues, 3, numPoints)';                
                % Extract x, y, and z coordinates
                x = pointCloud(:, 1);
                y = pointCloud(:, 2);
                z = pointCloud(:, 3);
                % Plot pointcloud
                colormap jet
                scatter3(x, y, z, 1, z, 'filled','Parent',pointcloud_ax);
                xlabel('X');
                ylabel('Y');
                zlabel('Z');
                title('LIDAR Pointcloud');
                colorbar;
                axis equal;
                drawnow;
            end
        end

        function data = generate_commands(obj,verbose)
            if verbose
                fprintf('\n--------------------------------\n')
                fprintf('Transmit Data to Hunter SE:\n')
                fprintf('--------------------------------\n\n')
                % Monitor Hunter SE control commands
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
            end
            data = strcat('42["Bridge",{"V1 CoSim":"',num2str(obj.cosim_mode), ...
                          '","V1 PosX":"',num2str(obj.posX_command), ...
                          '","V1 PosY":"',num2str(obj.posY_command), ...
                          '","V1 PosZ":"',num2str(obj.posZ_command), ...
                          '","V1 RotX":"',num2str(obj.rotX_command), ...
                          '","V1 RotY":"',num2str(obj.rotY_command), ...
                          '","V1 RotZ":"',num2str(obj.rotZ_command), ...
                          '","V1 RotW":"',num2str(obj.rotW_command), ...
                          '","V1 Throttle":"',num2str(obj.throttle_command), ...
                          '","V1 Steering":"',num2str(obj.steering_command),'"}]');
        end
    end
end