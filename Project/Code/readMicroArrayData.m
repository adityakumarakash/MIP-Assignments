function [Data] = readMicroArrayData( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

D = textread(filename, '%s', 'delimiter', '\n');
D = D(1 : end - 1);
genes = size(D, 1);
temp = strsplit(D{1}, {' '});
samples = size(temp, 2) - 1;
Data = zeros(genes, samples);

for i = 1 : genes
   temp = strsplit(D{i}, {' '});
   arrValue = cellfun(@str2double, temp(2 : end));
   Data(i, :) = arrValue;
end

Data = Data';

end

