set ROOMS;

param min_capacity >= 0;
param guests >= 0;

param capacity {ROOMS} >=0;				# the amount of beds in a room
param price {ROOMS} >= 0;				# room price/night

var Occupation {ROOMS} binary;			# which rooms are included in solution
var occupied_rooms = sum {i in ROOMS} Occupation[i];

subject to Accommodation:				# selected rooms overall capacity have to be equal to guests
	sum {i in ROOMS} Occupation[i]*capacity[i] = if guests < min_capacity then min_capacity else guests;

minimize OPTIMUM:
	sum{i in ROOMS} Occupation[i]*price[i];