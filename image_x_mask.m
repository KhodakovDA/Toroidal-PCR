function [ int ] = image_times_mask( IMAGE, MASK )
 int = sum(sum(double(IMAGE) .* double(MASK))) / sum(double(MASK(:)));
end

