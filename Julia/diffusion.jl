#!/usr2/local/julia-1.8.2/bin/julia


#Ask for maximum size
print("What is the dimension of your room: ")
dimension = readline()
dimension = parse(Int64, dimension)

#Declaring cube and set it to zero
cube = zeros(dimension, dimension, dimension)


#Adding Partition
print("Would you like to add a partition to the room (y/n) : ")
  x = readline()
  if (x == "y")
   return 1
  else 
   return 0 
  end
flag = x

# if flag is equal to y(1)
if (flag == 1)
  px = ceil(Int64, dimension * .5)
  py = ceil(Int64, dimension * .25) 
  for j = py:dimension
    for k = 1:dimension 
      cube[px, j, k] = -1.0       #adding wall of partition of -1
    end
  end  
end


#Declaring variables
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / dimension
distance_between_blocks = room_dimension / dimension
d_term = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

#Et cube's first value
cube[1, 1, 1] = 1.0e21

time = 0.0
ratio = 0.0

#Main Loop
while ratio < 0.99

  for i = 1:dimension
    for j = 1:dimension
      for k = 1:dimension
        for l = 1:dimension
          for m = 1:dimension
            for n = 1:dimension
              if i == l && j == m && k == n + 1 ||
                 i == l && j == m && k == n - 1 ||
                 i == l && j == m + 1 && k == n ||
                 i == l && j == m - 1 && k == n ||
                 i == l + 1 && j == m && k == n ||
                 i == l - 1 && j == m && k == n 
                 if cube[i, j, k] != -1 && cube[l, m, n] != -1            #Check for wall
                     global change = ( cube[i, j, k] - cube[l, m, n] ) * d_term
                     global cube[i, j, k] = cube[i, j, k] - change
                     global cube[l, m, n] = cube[l, m, n] + change
                 end
              end
            end
          end
        end
      end
    end
  end

  #updates global time variable
  global time = time + timestep
  
  sumval = 0.0
  
  #intializing min and max values
  maxval = cube[1, 1, 1]  
  minval = cube[1, 1, 1]
  for i = 1:dimension
    for j = 1:dimension
      for k = 1:dimension
          if cube[k,j,i] == -1                  # check for wall
              continue
          end
          maxval = max(cube[i, j, k], maxval)
          minval = min(cube[i, j, k], minval)
          sumval = sumval + cube[i, j, k]
      end
    end 
  end 
  
  #updating global ratio variable
  global ratio = minval / maxval
  
  #priniting the ratio and time for the user
  print(ratio)
  print("        ")
  println(time)

end  


  #printing end statement
  println("The box equilibrated in $time seconds of simulation time.")

exit()



