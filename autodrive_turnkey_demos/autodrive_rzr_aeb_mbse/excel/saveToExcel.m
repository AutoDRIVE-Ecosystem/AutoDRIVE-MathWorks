classdef SaveToExcel < handle
    % EXPORTTOEXCEL export a System Composer architecture model data to an Excel file.
    
    properties
        ExcelFileName;
    end
    
    methods
        function obj = SaveToExcel(xlFileName,exportedSet, savePath)
            % Exports model to an Excel file.
            obj.ExcelFileName = strcat(xlFileName,'.xls');
            
            if(nargin<3)
                savePath = '';
            end
            fileName = fullfile(savePath, obj.ExcelFileName);

            if ~isempty(exportedSet)
                componentTable = exportedSet.components;
                portsTable = exportedSet.ports;
                connectionTable = exportedSet.connections;
                portInterfaceTable = exportedSet.portInterfaces;
                requirementLinksTable = exportedSet.requirementLinks;
                try
                    % Setting off the AddSheet warning. As adding sheets to
                    % Excel file returns warning.
                    warning('off', 'MATLAB:xlswrite:AddSheet');
                    writetable(componentTable,fileName,'Sheet','Components');
                    writetable(portsTable,fileName,'Sheet','Ports');
                    writetable(connectionTable,fileName,'Sheet','Connections');
                    writetable(portInterfaceTable,fileName,'Sheet','PortInterfaces');
                    writetable(requirementLinksTable,fileName,'Sheet','RequirementLinks');
                    % Setting the warning back to on state.
                    warning('on', 'MATLAB:xlswrite:AddSheet');
                catch
                    % Setting the warning back to on state.
                    warning('on', 'MATLAB:xlswrite:AddSheet');
                    warning('Warning: Failed to export the model to Excel file');
                end
            else
                warning('Warning: Failed to export the model to Excel file');
            end
        end
    end
end

