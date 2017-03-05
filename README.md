## Terrain Elevation
An easy-to-use MATLAB library for working with terrain elevation from the USGS in 1/3 arc-second resolution. Supports automatic download and synthesization of multiple 1x1 degree cells, elevation data sampling, easy conversion from latitude/longitude to cartesian coordinates, and terrain visualization.

This library works in all of the mainland United States, Hawaii, and most of Alaska. It depends on the MATLAB Mapping Toolbox.

### Example usage (from example.m)

```
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
```

### MIT License
Copyright (c) 2017 Samuel Pfrommer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
