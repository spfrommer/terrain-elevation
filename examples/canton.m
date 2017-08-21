addpath('../')

region = fetchregion([40.40797, 40.410927], [-80.03197, -80.029418], ...
                     'dataDir', 'testDir', 'display', true);
elevData = region.readelevation([40.40797, 40.410927], ...
        [-80.03197, -80.029418], 'display', true);
dispelev(elevData, 'mode', 'cartesian');