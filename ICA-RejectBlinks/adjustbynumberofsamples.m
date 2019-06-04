function [matrixout] = adjustbynumberofsamples(matrixin)
%   Adjusts each value in a sample by the standard error of the sample
%
%   1   Input Matrix
%
%   tempmatrix= adjustbynumberofsamples(tempmatrix);
%
%   Author: Matthew B. Pontifex, Health Behaviors and Cognition Laboratory, Michigan State University, January 16, 2015
    
    r = size(matrixin, 1);
    c = size(matrixin, 2);

    if (c == 1)
        if (r > 1)
            matrixin = matrixin';
            r = size(matrixin, 1);
            c = size(matrixin, 2);
        else
            error('Error at adjustbynumberofsamples(). This function requires more than 1 value.');
        end
    end

    %Zscore columns
    tempmatrix = matrixin;
    for rN = 1:r
        for cN = 1:c
            tempmatrix(rN,cN) = matrixin(rN,cN)/sqrt(c);
        end
    end
    matrixout = tempmatrix;
end