PROGRAM Diffusion
    implicit none
    
    !Declaring variables 
    real (kind = 8) :: sumval
    real (kind = 8), dimension(:, :, :), allocatable :: cube
    real :: diffusion_coefficient, room_dimension, speed_of_gas_molecules, timestep, distance_between_blocks, DTerm
    real :: time, ratio, change, maxval, minval
    integer :: i, j, k, l, m, n, px, py, maxsize
    character :: flag
    
    !Ask for maximum size
    write(*,*) 'Type in the maximum size : '
    read(*,*) maxsize
    
    !Allocating size for the cube and initialize it to zero
    allocate( cube(0:maxsize-1, 0:maxsize-1, 0:maxsize-1)) 
    cube = 0.0
    
    !Asking user for partition 
    write(*,*) "Do you want to add a partition (y/n) : "
    read(*,*) flag
    
    ! if the flag is y
    if (flag == 'y') THEN 
      px = ceiling(maxsize * 0.5) - 1  ! Use lower median for even Msize
      py = ceiling(maxsize * (1-0.75)) - 1 ! Partition height (1-percent height) 
      do j = py, maxsize-1
          do k = 0, maxsize-1
              cube(px,j,k) = -1 ! Mark partition blocks with -1 
          end do
      end do
    end if
    
    !initialize variables
    time = 0.0
    ratio = 0.0
    diffusion_coefficient = 0.175
    room_dimension = 5.0
    speed_of_gas_molecules = 250.0
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)
    
    !!initializing the first cell 
    cube(0, 0, 0) = 1.0e21
    
    !Main loop
    do WHILE (ratio < 0.99)
      do i = 0, maxsize - 1
        do j = 0, maxsize - 1
          do k = 0, maxsize - 1
            do l = 0, maxsize - 1
              do m = 0, maxsize - 1
                do n = 0, maxsize - 1
                  if (( i == l .and. j == m .and. k == (n+1) ) .or. &
                     ( i == l .and. j == m .and. k == (n-1) ) .or.  &
                     ( i == l .and. j == (m+1) .and. k == n ) .or.  &
                     ( i == l .and. j == (m-1) .and. k == n ) .or.  &
                     ( i == (l+1) .and. j == m .and. k == n ) .or.  &
                     ( i == (l-1) .and. j == m .and. k == n )) THEN            
                         if ( cube (k, j, i) .NE. -1.0 .and. cube(n, m, l) .NE. -1.0 ) THEN   ! check for wall
                           change =  (cube(k, j, i) - cube(n, m, l)) * DTerm
                           cube(k, j, i) = cube (k, j, i) - change
                           cube(n, m, l) = cube(n, m, l) + change
                         end if
                  end if
              end do
            end do
          end do
        end do
      end do
    end do
      
      !Adjusting time
      time = time + timestep
      
      !Initializing minimum and maximum values
      maxval = cube(0, 0, 0)
      minval = cube(0, 0, 0)
      
      do i = 0, maxsize - 1
        do j = 0, maxsize - 1
          do k = 0, maxsize - 1
              if (cube(k,j,i) == -1) then      ! check for wall
                  cycle
              end if  
              maxval = max( cube(k, j, i), maxval)
              minval = min( cube(k, j, i), minval)
              sumval = sumval + cube(k, j, i)
          end do
        end do
      end do
      
      !update the ratio
      ratio = minval / maxval
      
      !printing time and ratio to the screen
      print *, ratio, " time = ", time
      
    end do !End of the large while 
    
    !Printing final time statement
    print *, " Box Equilibrated at ", time, " seconds of simulation time! "
    
    !Deallocate memory
    if ( allocated(cube) ) deallocate(cube)

end PROGRAM Diffusion
