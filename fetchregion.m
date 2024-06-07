function [ region ] = fetchregion( latRange, longRange, varargin )
%FETCHREGION Retrieves a region of USGS elevation data
%   Downloads, extracts, and indexes all 1x1 degree latitude/longitude
%   cells necessary to cover the specified latitude and longitude range
%   from the USGS database (1/3 arc-second, GeoTiff Format).
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
    
    % The 1 arc-second GeoTiff data is available at this root URL:
    % https://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Elevation/1/
    %
    % And the 1/3rd arc-second data is available at:
    % https://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Elevation/13/
    %
    % I'm hard coding to the 1/3rd arc-second resolution, which is good for
    % most of the mainland US. But some parts of Alaska are only available
    % in 1 arc-second so be aware of that.

    URL_FORMAT = 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/current/n%dw%03d/USGS_13_n%dw%03d.tif';
    DATAFILE_FORMAT = '/n%dw%03d.tif';
    
    [lats, longs] = rangeparse(inputs.latRange, inputs.longRange);
    
    region = Region;
    region.latCellRange = [lats(1) lats(end)];
    region.longCellRange = [longs(1) longs(end)];
    region.dataFiles = cell(length(lats), length(longs));
    
    if ~exist(inputs.dataDir, 'dir')
        status = mkdir(inputs.dataDir);
        if status == 0
            error('Could not create usgsdata directory.');
        end
    end
    
    for lat = lats
        for long = longs
            if inputs.display
                fprintf('-----Area n%dw%03d-----\n', lat, abs(long));
            end
            saveFile = strcat(inputs.dataDir, sprintf(DATAFILE_FORMAT, lat, abs(long)));
            url = sprintf(URL_FORMAT, lat, abs(long), lat, abs(long));
            
            if ~isfile(saveFile)
                if inputs.display
                    fprintf('Downloading area\n');
                end
                
                try
                    disp(url)
                    websave(saveFile, url);
                catch
                    delete(saveFile);
                    error('No data available for area n%dw%03d.', ...
                                  lat, abs(long));
                end
            else
               if inputs.display
                    fprintf('Area already downloaded\n');
                end 
            end
            
            % Copy the path to the raw data file into the appropriate
            % location in the region array
            region.dataFiles(lats(end) - lat + 1, abs(longs(1)) - ...
                             abs(long) + 1) = {saveFile};
        end
    end
end
