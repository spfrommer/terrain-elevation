function [ lats, longs ] = rangeparse( latRange, longRange )
%RANGEPARSE Finds the top left corner lats and longs of 1x1 degree cells 
%required to cover the given ranges
    latRange = [floor(min(latRange)), ceil(max(latRange))];
    longRange = [floor(min(longRange)), ceil(max(longRange))];
    lats = min(latRange):max(latRange);
    lats = lats(2:end);
    longs = min(longRange):max(longRange);
    longs = longs(1:end-1);
end

