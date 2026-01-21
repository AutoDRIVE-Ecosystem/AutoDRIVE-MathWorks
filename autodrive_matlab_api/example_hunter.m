classdef example_hunter < WebSocketServer
    % AutoDRIVE Hunter SE Example
    % Implements a MATLAB WebSocket server to communicate with AutoDRIVE
    % Simulator
    
    properties
        hunter_1 = autodrive_hunter;
        frontcamera_fig = figure(1)
        frontcamera_ax = axes;
        rearcamera_fig = figure(2)
        rearcamera_ax = axes;
        pointcloud_fig = figure(3)
        pointcloud_ax = axes;
    end
    
    methods
        function obj = example_hunter(varargin)
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
            obj.hunter_1.parse_data(in_data,obj.frontcamera_ax,obj.rearcamera_ax,obj.pointcloud_ax,true);            
            
            % Prepare outgoing data
            obj.hunter_1.cosim_mode = 0;
            obj.hunter_1.posX_command = 0;
            obj.hunter_1.posY_command = 0;
            obj.hunter_1.posZ_command = 0;
            obj.hunter_1.rotX_command = 0;
            obj.hunter_1.rotY_command = 0;
            obj.hunter_1.rotZ_command = 0;
            obj.hunter_1.rotW_command = 0;
            obj.hunter_1.throttle_command = 1;
            obj.hunter_1.steering_command = 1;
            % Encode outgoing data as a JSON message
            out_data = obj.hunter_1.generate_commands(true);
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

%autodrive = example_hunter(4567)
%autodrive.stop
%delete(autodrive)
%clear autodrive