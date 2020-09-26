function [finalCent] = refModel3(inputMatrix,inputCent)
%Summary of this function goes here
%   This function receives a fi matrix and a fi vector of 7 columns , where each line
%   represents a point in the 7 dim, represented in fixed point(MSB sign, 2
%   integer bits and 10 fractional bits)
%   It converts the matrix and vector to double, does k means on the matrix with initial values as in the vector
%   and returns the 8 centroids in a vector, also in fixed point
%   
%% convert matrix to double
%codegen
%cut the rows which are 0
zeroRowsVector = all(inputMatrix ==0,2);
zeroRows = sum(zeroRowsVector(:) ==1);
lastPointRow = 512 -zeroRows;
pointMatrix = double(inputMatrix(1:lastPointRow,:));

initialCent = double(inputCent);

%% do k means
[idx,R,sumd,D] = kmeans(pointMatrix,8,'EmptyAction','drop','Distance','cityblock','Start',initialCent,'Display','iter');

%round like this duo to code gen limitation : "Code generation supports only the syntax Y = round(X)."
R_round =round(R*1000)/1000;

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



