classdef autodrive_environment < handle
    % AutoDRIVE Environment API
    % Attributes and methods to store and parse environment commands

    properties
        % Environmental conditions
        auto_time
        auto_time_str
        time_scale
        time_of_day
        weather_id
        cloud_intensity
        fog_intensity
        rain_intensity
        snow_intensity
    end

    methods
        function data = generate_commands(obj,verbose)
            if(obj.auto_time == boolean(0))
                obj.auto_time_str = 'False';
            else
                obj.auto_time_str = 'True';
            end
            if verbose
                fprintf('\n--------------------------------\n')
                fprintf('Set Environmental Conditions:\n')
                fprintf('--------------------------------\n\n')
                % Monitor environmental conditions
                hours = floor(obj.time_of_day / 60);
                minutes = floor(mod(obj.time_of_day, 60));
                seconds = floor(mod(obj.time_of_day, 1) * 60);
                fprintf('Time: %d:%d:%.2f\n', hours, minutes, seconds)
                if obj.weather_id == 0
                    weather_str = sprintf('Custom | Clouds: %.2f%%\tFog: %.2f%%\tRain: %.2f%%\tSnow: %.2f%%', ...
                        round(obj.cloud_intensity * 100, 2), ...
                        round(obj.fog_intensity * 100, 2), ...
                        round(obj.rain_intensity * 100, 2), ...
                        round(obj.snow_intensity * 100, 2));
                elseif obj.weather_id == 1
                    weather_str = 'Sunny';
                elseif obj.weather_id == 2
                    weather_str = 'Cloudy';
                elseif obj.weather_id == 3
                    weather_str = 'Light Fog';
                elseif obj.weather_id == 4
                    weather_str = 'Heavy Fog';
                elseif obj.weather_id == 5
                    weather_str = 'Light Rain';
                elseif obj.weather_id == 6
                    weather_str = 'Heavy Rain';
                elseif obj.weather_id == 7
                    weather_str = 'Light Snow';
                elseif obj.weather_id == 8
                    weather_str = 'Heavy Snow';
                else
                    weather_str = 'Invalid';
                end
                fprintf('Weather: %s\n', weather_str)
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