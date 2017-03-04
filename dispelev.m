function [] = dispelev( elevData, varargin )
%DISPELEV Graphs the elevation data
%   DISPELEV(elevData) graphs the elevation data with gridlines
%
%   DISPELEV(...,'PropertyName',PropertyValue) specifies various
%   additional properties. The mode property affects the
%   axes units; 'latlong' units will use latitude and longitude for the x
%   and y axes (degrees) while 'cartesian' will use meters and scale the z 
%   limits accordingly (default latlong). The gridLines property specifies
%   the gridLine density (default 100 grid lines). Note that due to
%   discretization the actual number of grid lines will usually differ
%   slightly from the specified value.
    p = inputParser;
    p.addRequired('elevData', @(x) isa(x, 'ElevationData'));
    p.addParameter('mode', 'latlong', @isstr);
    p.addParameter('gridLines', 100, @(x) floor(x) == x && x > 0);
    p.parse(elevData, varargin{:});
    inputs = p.Results;
    
    % Get the sampling frequency based off of the desired number of grid
    % lines
    gridSample = ceil(max(length(elevData.lats), length(elevData.longs)) ...
                      / inputs.gridLines);
    
    if strcmp(inputs.mode, 'cartesian')
        [xs, ys] = inputs.elevData.getCartesian();
        
        % Get the desired axes bounds
        minX = min(xs(:));
        minY = min(ys(:));
        minElev = min(elevData.elev(:));
        axBound = max([max(xs(:)) - minX, max(ys(:)) - minY, ...
                       max(elevData.elev(:)) - minElev]);
        
        % Graph the elevation data without grid lines
        figure();
        hold on;
        surf(xs, ys, elevData.elev, 'LineStyle', 'none', ...
                                    'FaceLighting', 'phong');
        
        % Overlay grid lines at the desired intervals
        surf(xs(1:gridSample:size(xs, 1), :), ...
             ys(1:gridSample:size(ys, 1), :), ...
             elevData.elev(1:gridSample:size(elevData.elev, 1), :), ...
             'LineStyle', '-', 'FaceAlpha', 0, 'MeshStyle', 'row');
        surf(xs(:, 1:gridSample:size(xs, 2)), ...
             ys(:, 1:gridSample:size(ys, 2)), ...
             elevData.elev(:, 1:gridSample:size(elevData.elev, 2)), ...
             'LineStyle', '-', 'FaceAlpha', 0, 'MeshStyle', 'column');
        
        % Set axes bounds and labels
        axis([minX, minX + axBound, minY, minY + axBound, ...
              minElev, minElev + axBound]);
        xlabel('X Distance (meters)');
        ylabel('Y Distance (meters)');
        zlabel('Elevation (meters)');
        
        hold off;
    elseif strcmp(inputs.mode, 'latlong')
        % Graph the elevation data without gridlines
        figure();
        hold on;
        surf(elevData.longs, elevData.lats, elevData.elev, ...
            'LineStyle', 'none', 'FaceLighting', 'phong');
        
        % Overlay grid lines at the desired intervals
        surf(elevData.longs, ...
             elevData.lats(1:gridSample:length(elevData.lats)), ...
             elevData.elev(1:gridSample:size(elevData.elev, 1), :), ...
             'LineStyle', '-', 'FaceAlpha', 0, 'MeshStyle', 'row');
        surf(elevData.longs(1:gridSample:length(elevData.longs)), ...
             elevData.lats, ...
             elevData.elev(:, 1:gridSample:size(elevData.elev, 2)), ...
             'LineStyle', '-', 'FaceAlpha', 0, 'MeshStyle', 'col');
        
        % Label axes
        xlabel('Longitude (degrees)');
        ylabel('Latitude (degrees)');
        zlabel('Elevation (meters)');
        
        hold off;
    end
end