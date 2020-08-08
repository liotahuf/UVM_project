function [finalCent] = refModel(inputMatrix,inputCent)
%Summary of this function goes here
%   This function receives a string matrix and a vector of 7 columns , where each line
%   represents a point in the 7 dim, represented in fixed point(MSB sign, 2
%   integer bits and 10 fractional bits)
%   It converts the matrix and vector to double, does k means on the matrix with initial values as in the vector
%   and returns the 8 centroids in a vector, also in fixed point
%   
%% convert matrix to double
pointMatrix = inputMatrix
for c =1:8
    for l=1:size(inputMatrix,1)
        pointMatrix(l,c)=q2dec(inputMatrix(l,c),2,10,'bin');
    end
end

initialCent = inputCent;

for c=1:7
    for l=1:8
        initialCent(l,c)= q2dec(inputCent(l,c),2,10,'bin');
    end
end

%% do k means
[idx,R] = kmeans(pointMatrix,[],'Display','iter','EmptyAction','drop','Distance','cityblock','start',initialCent);

R_round =round(R,4);
for l=1:8
    for c=1:7
         if isnan(R_round(l,c))
             R_round(l,c) = initialCent(l,c);
             
         end
    end
end

%% convert centroid vector to fixed point

finalCent = inputCent;
for c=1:7
    for l=1:8
        finalCent(l,c)= dec2q(R_round(l,c),2,10,'bin');
    end
end
end

