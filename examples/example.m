addpath('../')

% Download the USGS 1/3 arc-second data covering northwestern Wyoming, from
% 42.5 to 45 latitude and from -111.05 to -108.6 longitude
region = fetchregion([42.5, 45], [-111.05, -108.6], 'display', true);
                           
% Read the elevation data for Yellowstone National Park (the indicated
% latitude and longitude range), sampling at 1/20th of the maximum
% resolution (i.e., 6 arc-seconds).
yellowstoneElevData = region.readelevation([44.255813, 44.649888], ...
                                           [-110.861772, -110.183366], ...
                                           'sampleFactor', 20, ...                                
                                           'display', true);

                                       
% Graph the elevation data for Yellowstone, using latitude and longitude
% for the x and y coordinates
dispelev(yellowstoneElevData, 'mode', 'latlong');

% Read the elevation data for the Jackson Hole resort (the indicated
% latitude and longitude range), sampling all data points (1/3 arc-seconds)
jacksonElevData = region.readelevation([43.450467, 43.546597], ...
                                       [-110.837225, -110.732854], ...
                                       'SampleFactor', 1, ...
                                       'display', true);
% Graph the elevation data for Jackson Hole, using meters for the x and y
% coordinates and specifying roughly 50 grid lines
dispelev(jacksonElevData, 'mode', 'cartesian', 'gridLines', 50);
