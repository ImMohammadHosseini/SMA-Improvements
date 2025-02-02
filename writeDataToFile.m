function writeDataToFile(data, filename)
    % Write data to a text file
    %
    % Parameters:
    % data - The data to be written (can be a matrix, cell array, etc.)
    % filename - The name of the text file to write the data to

    % Open the file for writing
    fileID = fopen(filename, 'a');
    
    % Check if the file opened successfully
    if fileID == -1
        error('Cannot open the file for writing: %s', filename);
    end

    % Write the data to the file
    if iscell(data)
        % If data is a cell array, write each element separately
        for i = 1:numel(data)
            if isnumeric(data{i})
                fprintf(fileID, '%f ', data{i});
            elseif ischar(data{i}) || isstring(data{i})
                fprintf(fileID, '%s ', data{i});
            end
        end
        fprintf(fileID, '\n');
    elseif isnumeric(data)
        % If data is numeric, write it as a matrix
        fprintf(fileID, '%f ', data);
        fprintf(fileID, '\n');
    elseif ischar(data) || isstring(data)
        % If data is a string or other type, convert to string and write
        fprintf(fileID, '%s\n', data);
    else
        error('Unsupported data type');
    end
    
    % Close the file
    fclose(fileID);

%     disp(['Data successfully written to ', filename]);
end
