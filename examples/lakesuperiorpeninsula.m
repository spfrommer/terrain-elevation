addpath('../')

region = fetchregion([47.037647, 47.577722], [-89.048325, -87.543198], ...
                     'display', true);
elevData = region.readelevation([47.037647, 47.577722], ...
                                [-89.048325, -87.543198], ...
                                'display', true, ...
                                'sampleFactor', 10);
dispelev(elevData, 'mode', 'cartesian', 'truez', true);
