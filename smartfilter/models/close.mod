set ROOMS;

param min_capacity >= 0;
param guests >= 0;

param capacity {ROOMS} >=0;				# the amount of beds in a room
param distance {ROOMS,ROOMS} >= 0;		# destination between rooms

var Occupation {ROOMS} binary;			# which rooms are included in solution
var occupied_rooms = sum {i in ROOMS} Occupation[i];

subject to Accommodation:				# selected overall room capacity has to be equal to guests or minimum room capacity
	sum {i in ROOMS} Occupation[i]*capacity[i] = if guests < min_capacity then min_capacity else guests;

minimize OPTIMUM:
	sum{(i,j) in {ROOMS,ROOMS}} (Occupation[i]*Occupation[j])*distance[i,j];