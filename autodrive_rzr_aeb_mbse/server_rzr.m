classdef server_rzr < WebSocketServer & handle
    % AutoDRIVE RZR Server
    % Implements a MATLAB WebSocket server to communicate with AutoDRIVE
    % Simulator
    
    properties
        rzr_1 = rzr;
    end
    
    methods
        function obj = server_rzr(varargin)
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
            obj.rzr_1.parse_data(in_data);            
            % Encode outgoing data as a JSON message
            out_data = obj.rzr_1.generate_commands();
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