classdef SimpleServer < WebSocketServer
    % SimpleServer
    % Implements a simple MATLAB WebSocket server
    
    properties
    end
    
    methods
        function obj = SimpleServer(varargin)
            %Constructor
            obj@WebSocketServer(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onTextMessage(obj,conn,message)
            % This function sends an echo back to the client
            conn.send(message); % Echo
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

