use std::io;
use std::io::Write;


fn main() {
  
  //Ask for user input for the maximum size
  //Resources: https://www.youtube.com/watch?v=07pDD0uLjYc
  let mut maxsize = String::new();
  println!("Enter The Maximum Size: ");
  match io::stdin().read_line(&mut maxsize)
  {
    Ok(_) => {
      println!("You have entered the maximum size of: {}", maxsize.trim() );
    }, 
    Err(_e) => println!("Error")
  }
    std::io::stdout().flush().expect("some error message");
  
  //Convert User input to integer
  //https://www.youtube.com/watch?v=enzwhb8sOSQ
  let maxsize : i64 = maxsize.trim().parse().unwrap();


   //create and initialize the cube to zero
  let mut cube = vec![vec![vec![0.0; maxsize as usize]; maxsize as usize]; maxsize as usize];   
  
  //Declaring variables 
  let diffusion_coefficient = 0.175;
  let room_maxsize = 5.0;
  let speed_of_gas_molecules = 250.0;
  let timestep = (room_maxsize as f64 / speed_of_gas_molecules) / maxsize as f64;
  let distance_between_blocks = room_maxsize / maxsize as f64;
  let dterm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks) as f64;
  
  //Initialize the cube
  cube[0][0][0] = 1.0e21;   
  
   //Ask for partition
   let mut flag = String::new();
   println!("Would you like to add a partition (y/n) : ");
   match io::stdin().read_line(&mut flag)
  {
    Ok(_) => {
      println!("You have select {} for partition", flag.trim() );
    }, 
    Err(_e) => println!("Error")
  }
  std::io::stdout().flush().expect("some error message");
  println!(" {}", flag.trim());
   
   
   //if flag is y
   if flag.trim() == "y" {
     let px: usize = ((maxsize as f64 * 0.5).ceil() - 1.0) as usize; // partition x-coordinate
       let py: usize = ((maxsize as f64 * (1.0-0.75)).ceil() - 1.0) as usize; //partition y-coordinate
       for j in py as i64..maxsize {
          for k in 0..maxsize {
             cube[px][j as usize][k as usize] = -1.0;
          }
       }
   }
 
  
  //Declare Variables
  let mut time = 0.0;
  let mut ratio = 0.0;
  
  //Main loop
  while ratio < 0.99 {
    for i in 0..maxsize as i64 {
      for j in 0..maxsize as i64{
        for k in 0..maxsize as i64{
          for l in 0..maxsize as i64{
            for m in 0..maxsize as i64{
              for n in 0..maxsize as i64{
                if  i == l && j == m && k == (n + 1)  ||
                    i == l && j == m && k == (n - 1)  ||      
                    i == l && j == (m + 1) && k == n  ||
                    i == l && j == (m - 1) && k == n  ||
                    i == (l + 1) && j == m && k == n  ||
                    i == (l - 1) && j == m && k == n  {
                    if cube[i as usize][j as usize][k as usize] != -1.0 && cube[l as usize][m as usize][n as usize] != -1.0 { 
                       let change: f64 = (cube[i as usize][j as usize][k as usize] - cube[l as usize][m as usize][n as usize]) * dterm;
                       cube[i as usize][j as usize][k as usize] = cube[i as usize][j as usize][k as usize] - change;
                       cube[l as usize][m as usize][n as usize] = cube[l as usize][m as usize][n as usize] + change;
                  }
                }
              }
            }
          }
        }
      }
    }
    
    time = time + timestep;
    
    //Declaring  / initializing variables for bottom loop
    let mut sumval = 0.0;
    let mut maxval = cube[0][0][0];
    let mut minval = cube[0][0][0];
    
    for i in 0..maxsize{
      for j in 0..maxsize{
        for k in 0..maxsize{  
          if cube[i as usize][j as usize][k as usize] == -1.0 {          //if does not equal wall
               continue;
            }
            maxval = cube[i as usize][j as usize][k as usize].max(maxval);
            minval = cube[i as usize][j as usize][k as usize].min(minval);
            sumval = sumval + cube[i as usize][j as usize][k as usize];
          
        }
      }
    }
    
    //Updating ratio
    ratio = minval / maxval;
    //println!(" {}", maxval);
    //println!(" {}", minval);
    println!("{} time = {}", ratio, time);
    //println!("{} {}", time, cube[0][0][0]);
    //println!(" {}", cube[maxsize-1][0][0]);  
    //println!(" {}", cube[maxsize-1][maxsize-1][0]);  
    //println!(" {}", cube[maxsize-1][maxsize-1][maxsize-1]);  
    //println!(" {}", sumval);
  } //End while loop
  

  println!("Box equilibrated in {} seconds of simulation time. ", time);
} 