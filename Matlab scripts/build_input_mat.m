inputCent = fi(zeros(8,7),1,13,10)
inputCent (1,7) = fi(q2dec(dec2bin(1,13),2,10,'bin'),1,13,10)
inputCent (2,7) = fi(q2dec(dec2bin(2,13),2,10,'bin'),1,13,10)
inputCent (3,7) = fi(q2dec(dec2bin(3,13),2,10,'bin'),1,13,10)
inputCent (4,7) = fi(q2dec(dec2bin(4,13),2,10,'bin'),1,13,10)
inputCent (5,7) = fi(q2dec(dec2bin(5,13),2,10,'bin'),1,13,10)
inputCent (6,7) = fi(q2dec(dec2bin(6,13),2,10,'bin'),1,13,10)
inputCent (7,7) = fi(q2dec(dec2bin(7,13),2,10,'bin'),1,13,10)
inputCent (8,7) = fi(q2dec(dec2bin(8,13),2,10,'bin'),1,13,10)

inputMatrix = fi(zeros(512,7),1,13,10)
inputMatrix(1,7) = fi(q2dec(dec2bin(11,13),2,10,'bin'),1,13,10)
inputMatrix(2,7) = fi(q2dec(dec2bin(12,13),2,10,'bin'),1,13,10)
inputMatrix(3,7) = fi(q2dec(dec2bin(13,13),2,10,'bin'),1,13,10)
inputMatrix(4,7) = fi(q2dec(dec2bin(14,13),2,10,'bin'),1,13,10)
inputMatrix(5,7) = fi(q2dec(dec2bin(15,13),2,10,'bin'),1,13,10)
inputMatrix(6,7) = fi(q2dec(dec2bin(16,13),2,10,'bin'),1,13,10)
inputMatrix(7,7) = fi(q2dec(dec2bin(17,13),2,10,'bin'),1,13,10)
inputMatrix(8,7) = fi(q2dec(dec2bin(18,13),2,10,'bin'),1,13,10)

inputMatrix(9,6) = fi(q2dec(dec2bin(7,13),2,10,'bin'),1,13,10)
%inputMatrix(9,7) = fi(q2dec(dec2bin(2,13),2,10,'bin'),1,13,10)
inputMatrix(10,7) = fi(q2dec(dec2bin(7,13),2,10,'bin'),1,13,10)
inputMatrix(10,5) = fi(q2dec(dec2bin(17,13),2,10,'bin'),1,13,10)



last_point_coord7 = '1000110001000' %"1"188
last_point_coord6 = '0001111101100' %"1"7d9
last_point_coord5 = '1100000010010' %"1"048
last_point_coord4 = '1000100111100' 
last_point_coord3 = '0111100001111' 
last_point_coord2 = '1010111010000' 
last_point_coord1 = '1010111101001' 

inputMatrix(10,7) = fi(q2dec(last_point_coord7,2,10,'bin'),1,13,10)
inputMatrix(10,6) = fi(q2dec(last_point_coord6,2,10,'bin'),1,13,10)
inputMatrix(10,5) = fi(q2dec(last_point_coord5,2,10,'bin'),1,13,10)
inputMatrix(10,4) = fi(q2dec(last_point_coord4,2,10,'bin'),1,13,10)
inputMatrix(10,3) = fi(q2dec(last_point_coord3,2,10,'bin'),1,13,10)
inputMatrix(10,2) = fi(q2dec(last_point_coord2,2,10,'bin'),1,13,10)
inputMatrix(10,1) = fi(q2dec(last_point_coord1,2,10,'bin'),1,13,10)

finalCentHex = hex(finalCent)
inputMatrixHex = hex(inputMatrix)
