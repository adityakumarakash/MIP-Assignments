function [ mew, var ] = MStep( Y, Mask, members, k )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mew = zeros(k, 1);
var = zeros(k, 1);

for i = 1 : k
    members(:, :, i) = members(:, :, i) .* Mask;
    mew(i) = sum(sum(members(:, :, i) .* Y)) / sum(sum(members(:, :, i)));
    var(i) = sum(sum(members(:, :, i) .* ((Y - mew(i)) .* (Y - mew(i))))) / sum(sum(members(:, :, i)));
end 

end

