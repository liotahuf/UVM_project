function [finalCent] = refModel2(inputMatrix,inputCent)
%Summary of this function goes here
%   This function receives a fi matrix and a fi vector of 7 columns , where each line
%   represents a point in the 7 dim, represented in fixed point(MSB sign, 2
%   integer bits and 10 fractional bits)
%   It converts the matrix and vector to double, does k means on the matrix with initial values as in the vector
%   and returns the 8 centroids in a vector, also in fixed point
%   
%% convert matrix to double
pointMatrix = double(inputMatrix);

initialCent = double(inputCent);

%% do k means
[idx,R] = kmeans(pointMatrix,[],'Display','iter','EmptyAction','drop','Distance','cityblock','start',initialCent);

R_round =round(R,3);
for l=1:8
    for c=1:7
         if isnan(R_round(l,c))
             R_round(l,c) = initialCent(l,c);
             
         end
    end
end

%% convert centroid vector to fixed point

finalCent = fi(R_round,1,13,10);


end



