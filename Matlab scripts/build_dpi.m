% Build the checker, specifying input data types
dpigen -args {fi(zeros(512,7),1,13,10),fi(zeros(8,7),1,13,10)} refModel2.m -rowmajor -launchreport -FixedPointDataType BitVector
