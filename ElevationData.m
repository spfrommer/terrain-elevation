classdef ElevationData
    %ELEVATIONDATA An elevation data container
    
    properties
        elev % A matrix of elevation data
        lats % Vector of latitudes associated with rows of elev
        longs % Vector of longitudes associated with columns of elev
    end
    
    methods
        function [xs, ys] = getCartesian(obj)
        % GETCARTESIAN Converts lats and longs into cartesian coordinates
        %   [xs, ys] = GETCARTESIAN() returns the x and y coordinate
        %   matrices, lining up one-to-one with each element of elev. The
        %   bottom left hand corner becomes [0, 0]. For larger areas, the
        %   resulting cartesian shape may seem warped due to the curvature
        %   of the earth (or squished at latitudes farther away from the
        %   equator).
            longFlip = obj.longs';
            [xs, ys] = grn2eqa(obj.lats(:,ones(length(obj.longs),1)), ...
                               longFlip(ones(length(obj.lats),1),:), ...
                               [min(obj.lats), min(obj.longs)], ...
                               referenceEllipsoid('earth'));
        end
    end    
end

