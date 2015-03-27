set ROOMS;

param min_capacity >= 0;
param min_dist >= 0;			
param min_price >= 0;
param pop_price >= 0;
param pop_dist >= 0;
param guests >= 0;

param capacity {ROOMS} >=0;				# the amount of beds in a room
param price {ROOMS} >= 0;				# room price/night
param distance {ROOMS,ROOMS} >= 0;		# destination between rooms

var Occupation {ROOMS} binary;			# which rooms are included in solution
var occupied_rooms = sum {i in ROOMS} Occupation[i];

subject to Accommodation:				# selected rooms overall capacity have to be equal to guests
	sum {i in ROOMS} Occupation[i]*capacity[i] = if guests < min_capacity then min_capacity else guests;

minimize OPTIMUM:
	sqrt((sum{i in ROOMS} Occupation[i]*((price[i]-min_price)^2))/pop_price + 1)/min_price + 
	if occupied_rooms > 1 then (
		sqrt((sum{(i,j) in {ROOMS,ROOMS}} (Occupation[i]*Occupation[j])*((distance[i,j]-min_dist)^2))/occupied_rooms + 1)
				/min_dist
	);