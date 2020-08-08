%%Input points
% Create input point matrix, transform it into fixed point and then into
% fixed bin representation
numOfPoints =randi([8,512],1,1);
randMatrix =-3.278 + (3.546-(-3.278))*rand(numOfPoints,7);
for l=1:numOfPoints
    for  c =1:7
        fixedPointRandMatrixBin(l,[1+13*(c-1):c*13])=dec2q(randMatrix(l,c),2,10,'bin');
    end
end

%% Initial Centroid vector
initialCent =-3.278 + (3.546-(-3.278))*rand(8,7);

for l=1:8
    for  c =1:7
        fixedPointinitialCentBin(l,[1+13*(c-1):c*13])=dec2q(initialCent(l,c),2,10,'bin');
    end
end


%% Expected results
[idx,expectedCentVec] = kmeans(randMatrix,[],'Display','iter','EmptyAction','drop','Distance','cityblock','start',initialCent);
expectedCentVec =round(expectedCentVec,4);
for l=1:8
    for c=1:7
         if isnan(expectedCentVec(l,c))
             expectedCentVec(l,c) = initialCent(l,c);
             
         end
    end
end


for l=1:8
    for  c =1:7
        expectedCentVecFixedPointBin(l,[1+13*(c-1):c*13])=dec2q(expectedCentVec(l,c),2,10,'bin');
    end
end

