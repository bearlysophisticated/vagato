set ROOMS;

param min_capacity >= 0;
param min_price = 1;
param guests >= 0;

param capacity {ROOMS} >=0;    # the amount of beds in a room
param stars {ROOMS} >=0;                                # average rating
param price {ROOMS} >= 0;    # room price/night

var Occupation {ROOMS} binary;   # which rooms are included in solution
var occupied_rooms = sum {i in ROOMS} Occupation[i];

subject to Accommodation:    # selected rooms overall capacity have to be equal to guests
sum {i in ROOMS} Occupation[i]*capacity[i] = if guests < min_capacity then min_capacity else guests;

minimize OPTIMUM:
sqrt((sum{i in ROOMS} Occupation[i]*(price[i]-min_price)^2)/occupied_rooms + 1)/min_price + 
sqrt((sum{i in ROOMS} Occupation[i]*(stars[i]-10)^2)/occupied_rooms + 1)/10;