classdef SimpleClient < WebSocketClient
    % SimpleClient
    % Implements a simple MATLAB WebSocket client
    
    properties
    end
    
    methods
        function obj = SimpleClient(varargin)
            %Constructor
            obj@WebSocketClient(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
        
        function onTextMessage(obj,message)
            % This function simply displays the message received
            fprintf('Message received:\n%s\n',message);
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
    end
end

