function[d] = hcompare_EMD(h1,h2)
% This function calculates Earth Movers Distance between two normalized
% histograms h1 and h2. Normalized histogram is histogram h, that has at
% each i place in it, value:
% (number of picture pixels with gray level i-1) / 
% (total num of pixels in picture).


% ALternative fast way:
d = sum(abs(cumsum(h1) - cumsum(h2)));
end
