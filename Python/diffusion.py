#!/usr/bin/python3
#imported libraries
import sys
import math
from numpy import *



#main function for all code 
def main() :
  #intialize maximum cube size
  maxsize = int(input("Enter the maximum size: "))
  
  #zeroing the cube with a loop
  cube = zeros((maxsize, maxsize, maxsize), dtype = 'double')   # Initialize a 3D-array with zeroes
  
  
  #adding partition
  flag = input("Would you like to add a partition to this room (y / n) : ")
  if (flag == "y") :
    flag = True
  elif (flag == "n") :
    flag = False
  if (flag) :
    px = (math.ceil(maxsize * .5)) - 1
    py = (math.ceil(maxsize * .25)) - 1    
    for i in range (py, maxsize) :
      for j in range (0, maxsize) :
        cube[px][i][j] = -1.0
        
  
  #intializing variables
  diffusion_coefficient = 0.175
  room_dimension = 5
  speed_of_gas_molecules = 250.0
  timestep = (room_dimension / speed_of_gas_molecules) / maxsize
  distance_between_blocks = room_dimension / maxsize
  DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)
  time = 0.0
  ratio = 0.0
  
  #initialize first cell
  cube[0][0][0] = 1.0e21
  
  #Main loop 
  while ratio < 0.99 :          
    for i in range(0, maxsize) :
      for j in range(0, maxsize) :
        for k in range(0, maxsize) :
          for l in range(0, maxsize) :
            for m in range(0, maxsize) :
              for n in range(0, maxsize) :
                if (((i == l) and (j == m) and (k == n+1) or
                     (i == l) and (j == m) and (k == n-1) or 
                     (i == l) and (j == m+1) and (k == n) or
                     (i == l) and (j == m-1) and (k == n) or 
                     (i == l+1) and (j == m) and (k == n) or
                     (i == l-1) and (j == m) and (k == n))) :
                       if (cube[i][j][k] != -1 and cube[l][m][n] != -1) :   ##Check if there is wall
                         change = (cube[i][j][k] - cube[l][m][n]) * DTerm
                         cube[i][j][k] = cube[i][j][k] - change
                         cube[l][m][n] = cube[l][m][n] + change
    
    ##adjusting time variable                     
    time = time + timestep
    
    ##finding min / max values
    sumval = 0.0
    maxval = cube[0][0][0]
    minval = cube[0][0][0]
    for i in range(0, maxsize) :
      for j in range(0, maxsize) :
        for k in range(0, maxsize) : 
          if (cube[i][j][k] != -1) :          ##Check if there is wall
            maxval = max(cube[i][j][k],maxval)
            minval = min(cube[i][j][k],minval)
            sumval += cube[i][j][k]
    
    #Calculating the ratio      
    ratio = minval / maxval
    
    #Printing the ratio
    print( ratio , " time = " , time )
    #print( time , " " , cube[0][0][0])
    #print(" " , cube[maxsize-1][0][0]) 
    #print(" " , cube[maxsize-1][maxsize-1][0])
    #print(" " ,cube[maxsize-1][maxsize-1][maxsize-1])
    #print(" " , sumval , "\n")
    
    #printing last statement
  print( "Box equilibrated in " + str(time) + " seconds of simulated time." )
  
#call to main function
main()
