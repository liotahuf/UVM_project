function [finalCent] = refModel3(inputMatrix,inputCent,inputThreshold,inputFirstPoint,inputLastPoint)
%Summary of this function goes here
%  
%   
%   
%  
%   
%% initiate 


firstPointRow=double(inputFirstPoint);
lastPointRow=double(inputLastPoint);
finalCent = inputCent
%finalCent.RoundingMethod ='Floor'
pointMatrix = inputMatrix(firstPointRow:lastPointRow,:);

numRows =  lastPointRow- firstPointRow +1 
threshold = double(inputThreshold)
%initialCent = double(inputCent);

%% do k means
converged=0
currentCent = finalCent
%currentCent.RoundingMethod = 'Floor'
iterations = 0
while(converged == 0)
    iterations =iterations+1
    if(iterations>10e100000)
        break
    end
    acummulators = fi(zeros(8,7),1,22,10);
    %acummulators.RoundingMethod = 'Floor'
    acummuCnts = fi(zeros(8,1),0,9,0);
    currentCent = finalCent
    %currentCent.RoundingMethod = 'Floor'
    %calculate distance and add to acumulator 
    for i=1:numRows
       point = pointMatrix(i,:);
       distances = zeros(8,1);
       for j=1:8
           distances(j,:) = sum(abs(currentCent(j,:) - point),2);
       end
       [M,I] =  min(distances);
       acummulators(I,:) = acummulators(I,:) +point;
       acummuCnts(I)=acummuCnts(I)+1;
    end
    %calculate new centroids and check convergence
    convegrnceCnt =0
    for i=1:8
        if(acummuCnts(i)>0)
            %currAcummDouble = round(double(acummulators(i,:)*1000))/1000;
            %currCentDouble = currAcummDouble/acummuCnts(i);
            %currentCent(i,:) = fi(currCentDouble,1,13,10,'RoundingMethod','Floor')
            %currentCent(i,:) = (floor(currentCent(i,:).*1000))/1000;
            currentCent(i,:) = acummulators(i,:)/acummuCnts(i);
            if(sum(abs(currentCent(i,:) - finalCent(i,:)),2) <= inputThreshold)
                convegrnceCnt=convegrnceCnt+1
            end    
        else
            convegrnceCnt=convegrnceCnt+1
        end
    end
    if(convegrnceCnt ==8)
        converged=1
    else
        finalCent =currentCent
    end    
    


end



