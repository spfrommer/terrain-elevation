% From https://github.com/spfrommer/terrain-elevation/issues/2 

latRange = [39.857760, 39.871599];
lonRange = [-84.840554, -84.822595];
region = fetchregion(latRange, lonRange, 'display', true);
elevData = region.readelevation(...
    latRange, lonRange, ...
    'sampleFactor', 1, ...
    'display', true);

dispelev(elevData, 'mode', 'cartesian', 'truez', true);

