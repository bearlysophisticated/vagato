set ROOMS;

param min_capacity >= 0;
param min_distance = 1;
param guests >= 0;

param capacity {ROOMS} >=0;    # the amount of beds in a room
param stars {ROOMS} >=0;                                # average rating
param distance {ROOMS,ROOMS} >= 0;  # destination between rooms

var Occupation {ROOMS} binary;   # which rooms are included in solution
var occupied_rooms = sum {i in ROOMS} Occupation[i];

subject to Accommodation:    # selected overall room capacity has to be equal to guests or minimum room capacity
sum {i in ROOMS} Occupation[i]*capacity[i] = if guests < min_capacity then min_capacity else guests;

minimize OPTIMUM:
	sqrt((sum{(i,j) in {ROOMS,ROOMS}} (Occupation[i]*Occupation[j])*(distance[i,j] - min_distance)^2)/occupied_rooms + 1)/min_distance + 
    sqrt((sum{i in ROOMS} Occupation[i]*((stars[i]-10)^2))/occupied_rooms + 1)/10;