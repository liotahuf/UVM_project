% Build the checker, specifying input data types
dpigen -args {fi(zeros(512,7),1,13,10,'RoundingMethod','Floor'),fi(zeros(8,7),1,13,10,'RoundingMethod','Floor'),fi(zeros(1,1),1,13,10),fi(zeros(1,1),0,13,0),fi(zeros(1,1),0,13,0)} refModel3.m -rowmajor -launchreport -FixedPointDataType BitVector
