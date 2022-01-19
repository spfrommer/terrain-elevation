function [ region ] = fetchregion( latRange, longRange, varargin )
%FETCHREGION Retrieves a region of USGS elevation data
%   Downloads, extracts, and indexes all 1x1 degree latitude/longitude
%   cells necessary to cover the specified latitude and longitude range
%   from the USGS database (1/3 arc-second, GridFloat format).
%
%   region = FETCHREGION(latRange, longRange) downloads and extracts all
%   cells necessary to cover latRange/longRange and returns a Region object
%   containing relevant data file paths
%
%   region = FETCHREGION(...,'PropertyName',PropertyValue) specifies
%   various additional properties. The dataDir property indicates the name
%   of the directory in which to store the USGS cell data (default
%   'usgsdata'. The display property is a boolean which specifies whether
%   the debug print statements should be outputted (default false).
    p = inputParser;
    p.addRequired('latRange', @(x) length(x) == 2);
    p.addRequired('longRange', @(x) length(x) == 2);
    p.addParameter('dataDir', 'usgsdata', @isstr);
    p.addParameter('display', false, @(x) isa(x, 'logical'));
    p.parse(latRange, longRange, varargin{:});
    inputs = p.Results;
    
    % There are two URL formats for accessing USGS 1/3 arc-second GridFloat 
    % data, probably due to different data sets being published at
    % different times. If a third URL format exists that I missed please
    % let me know.
    URL_FORMAT =  'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/GridFloat/USGS_NED_1_n%dw%03d_GridFloat.zip';
    DATAFILE_FORMAT = '/usgs_ned_1_n%dw%03d_gridfloat.flt';
    
    [lats, longs] = rangeparse(inputs.latRange, inputs.longRange);
    
    region = Region;
    region.latCellRange = [lats(1) lats(end)];
    region.longCellRange = [longs(1) longs(end)];
    region.fltDataFiles = cell(length(lats), length(longs));
    
    status = mkdir(inputs.dataDir);
    if status == 0
        error('Could not create usgsdata directory.');
    end
    
    for lat = lats
        for long = longs
            if inputs.display
                fprintf('-----Area n%dw%03d-----\n', lat, abs(long));
            end
            zipFile = strcat(inputs.dataDir, sprintf('/n%dw%03d.zip', lat, abs(long)));
            unzipDir = strcat(inputs.dataDir, sprintf('/n%dw%03d', lat, abs(long)));
            
            if ~exist(unzipDir, 'dir')
                if inputs.display
                    fprintf('Downloading area\n');
                end
                
                % Download the zipped files from the USGS server, trying
                % both possible formats
                try
                    websave(zipFile, sprintf(URL_FORMAT, lat, abs(long)));
                catch
                    delete(zipFile);
                    error('No data available for area n%dw%03d.', ...
                                  lat, abs(long));
                end
                
                % Extract the zip file
                try
                    if inputs.display
                        fprintf('Extracting area\n');
                    end
                    unzip(zipFile, unzipDir);
                catch
                    error('Unable to unzip. Probably corrupted data.');
                end
                delete(zipFile);
            else
               if inputs.display
                    fprintf('Area already downloaded\n');
                end 
            end
            
            % Copy the path to the raw data file into the appropriate
            % location in the region array
            dataFile = strcat(unzipDir, sprintf(DATAFILE_FORMAT, lat, abs(long)));
            if exist(dataFile, 'file')
                region.fltDataFiles(lats(end) - lat + 1, abs(longs(1)) - ...
                                    abs(long) + 1) = {dataFile};
            else
                error('Could not locate gridfloat data in USGS download.');
            end
        end
    end
end

