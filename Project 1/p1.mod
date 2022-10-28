# Sets
set PLACES;                      # All places: Parking, School and Stops            
set ORIGIN within PLACES;        # Only Parking 
set NON_ORIGIN within PLACES;    # All but Parking
set NON_FINAL within PLACES;     # All but School
set FINAL within NON_ORIGIN;     # Only School
set STOPS within NON_ORIGIN;     # Only the Stops

# Parameters
param students {s in STOPS};                        # Defines the num
param distance {i in PLACES, j in PLACES};          # Defines the distance between places
param number_of_buses;                              # Defines number of buses at dispose
param bus_capacity;                                 # Defines the ammount of students a bus can fit
param bus_cost;                                     # Defines the cost of using a bus
param cost_distance;                                # Defines the cost of each unit of distance

# Decission variables
var route {i in PLACES, j in PLACES} binary;              # Binary decission variable that indicates if the route from one place to another has been used by a bus
var flux {i in PLACES, j in PLACES} integer, >= 0;        # Integer decission varaible that defines the amount of students travelling in the bus from one place to another

# Objective function
minimize cost:
  (bus_cost * sum {o in ORIGIN, s in STOPS} route [o,s]) + (cost_distance * sum {i in PLACES, j in PLACES}  distance[i,j] * route[i,j]);



# Constraints

# Only 1 bus can exit a stop
s.t. Max_1_out {s in STOPS} : sum {j in NON_ORIGIN} route [s,j] <= 1;  

# Only 1 bus can arrive at a stop
s.t. Max_1_in {s in STOPS} : sum {i in NON_FINAL} route [i,s] <= 1;    

# The number of buses out of the Parking does not exceed the ammount of buses at dispose
s.t. Total_buses : sum {o in ORIGIN, s in STOPS} route [o,s] <= number_of_buses;      

# The same number of buses that exit the Parking arrive at School
s.t. Buses_StartFinish : sum {o in ORIGIN, s in STOPS} route [o,s] = sum {i in STOPS, f in FINAL} route [i,f];    

# The ammount of students that arrive at a stop + the students waiting at that stop = the number of students that leave the stop in the bus
s.t. FlowIn_FlowOut {s in STOPS}: sum {j in NON_ORIGIN} flux [s,j] =  students [s] + sum{i in PLACES} flux [i,s];   

# The ammount of students traveling from one place to another never exceeds the bus capacity
s.t. Flow_lessthan_Capacity {i in PLACES, j in PLACES} : flux [i,j] <= route [i,j] * bus_capacity;


end;
