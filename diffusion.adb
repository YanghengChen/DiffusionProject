with ada.text_io, ada.integer_text_io, ada.float_text_io;
use ada.text_io, ada.integer_text_io, ada.float_text_io;

procedure diffusion is
  
--Initializing the main array
  type ThreeD_Array is array (Integer range <>, Integer range <>, Integer range <>) of Long_Float;
  maxsize : integer;
  flag : character;

begin
  
--Ask for the maximum size
  put("Type in the maximum size: ");
  get(maxsize);
  new_line;
  
  --Declaring Variables
  declare
    --Creating Cube and set it to zero
    cube :  ThreeD_Array ( 0..maxsize, 0..maxsize, 0..maxsize) := (others => (others => (others => 0.0)));
    diffusion_coefficient : Long_Float := 0.175;
    room_dimension : Long_Float := 5.0;
    speed_of_gas_molecules : Long_Float := 250.0;
    timestep : Long_Float := room_dimension / speed_of_gas_molecules / Long_Float(maxsize);
    distance_between_blocks : Long_Float := room_dimension / Long_Float(maxsize);
    d_term : Long_Float := (diffusion_coefficient * timestep) / Long_Float(distance_between_blocks * distance_between_blocks);
    ratio : Long_Float := 0.0;
    time : Long_Float := 0.0;
    change : Long_Float := 0.0;
    sumval : Long_Float := 0.0;  
    maxval : Long_Float := 0.0; 
    minval : Long_Float := 0.0;
    px : Integer := Integer(Float'Ceiling(Float(maxsize)*0.5)-1.0); -- use lower median for x 
    py : Integer := Integer(Float'Ceiling(Float(maxsize)*(1.0-0.75))-1.0); -- partition height as (1 - percent height)
    
    --Main program
    begin
    
    --Ask for partition
    put("Do you want to add a partition (y/n) : ");
    get(flag);
    begin
        if (flag = 'y') then
               for j in py..maxsize-1 loop
                   for k in 0..maxsize-1 loop
                       cube(px,j,k) := -1.0; 
                   end loop;
               end loop;
        end if; 
    end;
      
      --Intialize first cell
      cube(0, 0, 0) := 1.0e21;
      
     -- Main loop
      while ratio < 0.99 loop 
         for i in 0..maxsize loop
           for j in 0..maxsize loop
             for k in 0..maxsize loop
               for l in 0..maxsize loop
                 for m in 0..maxsize loop
                   for n in 0..maxsize loop
                     if (i = l and j = m and k = (n+1)) or
                        (i = l and j = m and k = (n-1)) or
                        (i = l and j = (m+1) and k = n) or
                        (i = l and j = (m-1) and k = n) or
                        (i = (l+1) and j = m and k = n) or
                        (i = (l-1) and j = m and k = n) then 
                        if ( cube (i, j, k) /= -1.0 and cube(l, m, n) /= -1.0 ) then     --Check the wall
                          change := (  cube(i, j, k) - cube(l, m, n)  ) * d_term;
                          cube(i, j, k) := cube(i, j, k) - change;
                          cube(l, m, n) := cube(l, m, n) + change;
                          end if;
                     end if;
                   end loop;
                 end loop;
               end loop;
             end loop;
           end loop;
         end loop;
         
    --Updating time
    time := time + timestep;
    
    --Initializing min and max values
    maxval := cube(0, 0, 0);
    minval := cube(0, 0, 0);
      
        for i in 0..maxsize loop
          for j in 0..maxsize loop
            for k in 0..maxsize loop
              if (cube (i, j, k) /= -1.0) then                   --Check the wall
                maxval := Long_Float'Max(cube(i, j, k), maxval);
                minval := Long_Float'Min(cube(i, j, k), minval);
                sumval := sumval + Long_Float(cube(i, j, k));
              end if;
            end loop;
          end loop;
        end loop;
    --Print the time and ratio of the room   
    ratio := minval / maxval;
    put(Float(ratio));
    put("          ");
    put(Float(time));
    new_line;
  end loop;    
    
    put("Box equilibrated in ");
    put(Float(time));
    put(" seconds of simulated time.");    
    
    end;    

end diffusion;    
