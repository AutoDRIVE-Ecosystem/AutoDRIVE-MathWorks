classdef example_rzr < WebSocketServer
    % AutoDRIVE RZR Example
    % Implements a MATLAB WebSocket server to communicate with AutoDRIVE
    % Simulator
    
    properties
        rzr_1 = autodrive_rzr;
        frontcamera_fig = figure(1)
        frontcamera_ax = axes;
        rearcamera_fig = figure(2)
        rearcamera_ax = axes;
        % pointcloud_fig = figure(3)
        % pointcloud_ax = axes;
    end
    
    methods
        function obj = example_rzr(varargin)
            % Constructor
            obj@WebSocketServer(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
        end

        function onTextMessage(obj,conn,message)
            % This function recieves the incoming data from WebSocket,
            % parses incoming data, prepares outgoing data, and transmits
            % the outgoing data over WebSocket

            % Recieve and decode incoming JSON message
            in_data = jsondecode(message(13:end-1));
            % Parse incoming data
            obj.rzr_1.parse_data(in_data,obj.frontcamera_ax,obj.rearcamera_ax,true);            
            
            % Prepare outgoing data
            obj.rzr_1.cosim_mode = 0;
            obj.rzr_1.posX_command = 0;
            obj.rzr_1.posY_command = 0;
            obj.rzr_1.posZ_command = 0;
            obj.rzr_1.rotX_command = 0;
            obj.rzr_1.rotY_command = 0;
            obj.rzr_1.rotZ_command = 0;
            obj.rzr_1.rotW_command = 0;
            obj.rzr_1.throttle_command = 0.5;
            obj.rzr_1.steering_command = 0;
            obj.rzr_1.brake_command = 0;
            obj.rzr_1.handbrake_command = 0;
            obj.rzr_1.headlights_command = 1;
            obj.rzr_1.env.auto_time = boolean(0);
            obj.rzr_1.env.time_scale = 60;
            obj.rzr_1.env.time_of_day = 560;
            obj.rzr_1.env.weather_id = uint8(3);
            obj.rzr_1.env.cloud_intensity = 0;
            obj.rzr_1.env.fog_intensity = 0;
            obj.rzr_1.env.rain_intensity = 0;
            obj.rzr_1.env.snow_intensity = 0;
            % Encode outgoing data as a JSON message
            out_data = obj.rzr_1.generate_commands(true);
            % Transmit outgoing JSON message
            conn.send(out_data);
        end
        
        function onBinaryMessage(obj,conn,bytearray)
            % This function sends an echo back to the client
            conn.send(bytearray); % Echo
        end
        
        function onError(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onClose(obj,conn,message)
            fprintf('%s\n',message)
        end
    end
end

%autodrive = example_rzr(4567)
%autodrive.stop
%delete(autodrive)
%clear autodrive