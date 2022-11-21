#include<cmath> 
#include<iostream>
using namespace std;

int main() {
    // Ask for maximum size
    int maxsize;  
    cout << "Enter the Maximum Size: ";
    cin >> maxsize; 

    // 3-D array
    double*** cube =  new double** [maxsize];
    
    for (int i = 0; i < maxsize; ++i) {
      cube[i] = new double* [maxsize];
        for (int j = 0; j < maxsize; j++) {
          cube[i][j] = new double [maxsize];
      }
    } 
    
    //set to zero
    for ( int i = 0; i < maxsize; i++ ) {
     for ( int j = 0; j < maxsize;j++ ) {
       for (int k = 0; k < maxsize; k++ ) {
         cube[i][j][k] = 0;
        }
      }
    }
        
    // ask for partition 
    bool flag;
    string in = "";
    cout << "Would you like to add a partition? (y / n) : ";
    cin >> in;
    if (in == "y") {
      flag = true;
    }
    else if (in == "n") {
      flag = false;
    }
   
   // if the flag is y
   if (flag == true) {
        int px = ceil(maxsize * .5) - 1;     
        int py = ceil(maxsize * .25) - 1;                             
        for (int i = py; i < maxsize; i++) {   //changed partition size here 
          for (int j = 0; j < maxsize; j++) {
            cube[px][i][j] = -1; //setting values to -1
          }
        }
      }
    
    
   



    //Declare variables
    double diffusion_coefficient = 0.175; 
    double room_dimension = 5;                      // 5 Meters
    double speed_of_gas_molecules = 250.0;          // Based on 100 g/mol gas at RT
    double timestep = (room_dimension / speed_of_gas_molecules) / maxsize; // h in seconds
    double distance_between_blocks = room_dimension / maxsize;
    double DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);

    cube[0][0][0] = 1.0e21; // Initialize the first cell
    double time = 0.0; // To keep up with accumulated time
    double ratio = 0.0;

    // Main loop
    do {
        for (int i=0; i<maxsize; i++) { 
            for (int j=0; j<maxsize; j++) { 
                for (int k=0; k<maxsize; k++) { 
                    for (int l=0; l<maxsize; l++) { 
                        for (int m=0; m<maxsize; m++) { 
                            for (int n=0; n<maxsize; n++) { 
                                if (((i == l) && (j == m) && (k == n+1)) ||  
                                    ((i == l) && (j == m) && (k == n-1)) ||  
                                    ((i == l) && (j == m+1) && (k == n)) ||  
                                    ((i == l) && (j == m-1) && (k == n)) ||  
                                    ((i == l+1) && (j == m) && (k == n)) ||  
                                    ((i == l-1) && (j == m) && (k == n)) ) {
                                        if (cube[i][j][k] != -1 && cube[l][m][n] != -1) {                //Check for the wall
                                            double change = (cube[i][j][k] - cube[l][m][n]) * DTerm;
                                            cube[i][j][k] = cube[i][j][k] - change;                                
                                            cube[l][m][n] = cube[l][m][n] + change;    
                                    }                               
                                }          
                            }
                        }
                    }             
                }
            }
        }  

        time =time +  timestep;   

        // initialize variables for minimums, maximums and total
        double sumval = 0.0;
        double maxval = cube[0][0][0]; 
        double minval = cube[0][0][0];

        // Find the minimum and the maximum value
        for (int i=0; i<maxsize; i++) { 
            for (int j=0; j<maxsize; j++) { 
                for (int k=0; k<maxsize; k++) { 
                    if (cube[i][j][k] != -1) {                        //Check for the wall
                      maxval = std::max(cube[i][j][k],maxval);
                      minval = std::min(cube[i][j][k],minval);
                      sumval += cube[i][j][k];                
                    }
                }
            }
        }
        ratio = minval / maxval;
        cout << time << "\t" << cube[0][0][0];
       /* 
        cout << time << "\t" << cube[0][0][0];
        cout <<         "\t" << cube[maxsize-1][0][0];
        cout <<         "\t" << cube[maxsize-1][maxsize-1][0];
        cout <<         "\t" << cube[maxsize-1][maxsize-1][maxsize-1];
        cout <<         "\t" << sumval << endl;
        */
    } while ( ratio <= 0.99 );
    
    // Free the RAM
    for (int i=0; i<maxsize; i++ ) {
        for (int j=0; j<maxsize; j++ ) {
            delete[] cube[i][j];
        }
        delete[] cube[i];
    }
    delete[] cube;
    
    cout << "Box equilibrated in " << time << " seconds of simulated time." << endl;
    
} 
