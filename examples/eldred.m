addpath('../')

region = fetchregion([34.095305, 34.109537], [-118.214006, -118.207687], ...
                     'display', true);
elevData = region.readelevation([34.095305, 34.109537], ...
           [-118.214006, -118.207687], 'display', true);
dispelev(elevData, 'mode', 'cartesian');