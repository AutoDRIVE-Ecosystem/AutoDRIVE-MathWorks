classdef environment < handle
    % AutoDRIVE Environment MATLAB API
    % Attributes and methods to store and parse environment commands

    properties
        % Environmental conditions
        auto_time = boolean(0)
        auto_time_str = "False"
        time_scale = 60
        time_of_day = 560
        weather_id = uint8(3)
        cloud_intensity = 0
        fog_intensity = 0
        rain_intensity = 0
        snow_intensity = 0
    end

    methods
        function data = generate_commands(obj)
            if(obj.auto_time == boolean(0))
                obj.auto_time_str = 'False';
            else
                obj.auto_time_str = 'True';
            end
            data = strcat('","Auto Time":"',obj.auto_time_str, ...
                          '","Time Scale":"',num2str(obj.time_scale), ...
                          '","Time":"',num2str(obj.time_of_day), ...
                          '","Weather":"',num2str(obj.weather_id), ...
                          '","Clouds":"',num2str(obj.cloud_intensity), ...
                          '","Fog":"',num2str(obj.fog_intensity), ...
                          '","Rain":"',num2str(obj.rain_intensity), ...
                          '","Snow":"',num2str(obj.snow_intensity));
        end
    end
end