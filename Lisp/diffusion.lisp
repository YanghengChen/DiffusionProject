#!/usr/bin/sbcl --script

;;Declaring Global Variables

(let ((maxsize)
      (flag)
      (cube)
      (diffusion_coefficient 0.175)
      (room_dimension 5.0)
      (speed_of_gas_molecules 250.0)
      (timestep)
      (distance_between_blocks)
      (DTerm)
      (change)
      (time_var 0.0)
      (ratio_var 0.0)
      (sumval 0.0)
      (minval 0.0)
      (maxval 0.0)
      (temp 0.0)
      (temp_var 0.0)
      (px)
      (py)
      )

;;Gathering input for maxsize
(princ "Enter the maximum size: ")
(finish-output)
(setf maxsize (read))
(coerce maxsize 'float)
(clear-input)
(terpri)

;;Setting main variables 

(setf timestep (/ (/ room_dimension speed_of_gas_molecules) maxsize))
(setf distance_between_blocks (/ room_dimension maxsize))
(setf DTerm (/ (* diffusion_coefficient timestep) (* distance_between_blocks distance_between_blocks)))

;; Creating / Declaring the cube

(setf cube (make-array (list maxsize maxsize maxsize)))

;;Filling Cube with all zeros
(loop for a from 0 to (- maxsize 1) do
  (loop for b from 0 to (- maxsize 1) do
    (loop for c from 0 to (- maxsize 1) do
      (setf (aref cube a b c) 0.0 ))))
      
;;asking for partition
(princ "Would you like to add a partition (y/n) : ")
(finish-output)
(setf flag (read))
(clear-input)
(terpri)

;; Setting partition wall when flag is y
 (when (string-equal flag "y")
 (setf px (- (ceiling (* maxsize 0.5)) 1))
          (setf py (- (ceiling (* maxsize (- 1 0.75))) 1)) ; Partition height (- 1 percent-heigh) where percent-height = 0.75
          (loop for j from py to (- maxsize 1) do
              (loop for k from 0 to (- maxsize 1) do
                  (setf (aref cube px j k) -1)))) ; Fill partition blocks with -1

;; Setting initial cube value

(setf (aref cube 0 0 0) 1.0e21)

;;Might want to set each of these variables individually

(loop while (< ratio_var 0.99) do

  (loop for i from 0 to (- maxsize 1) do
    (loop for j from 0 to (- maxsize 1) do
      (loop for k from 0 to (- maxsize 1) do
        (loop for l from 0 to (- maxsize 1) do
          (loop for m from 0 to (- maxsize 1) do
            (loop for n from 0 to (- maxsize 1) do
              (when (or (or (or (and (and (= i l) (= j m)) (= k (+ n 1)))
                    (and (and (= i l) (= j m)) (= k (- n 1))))
                    (or (and (and (= i l) (= j (+ m 1))) (= k n))
                    (and (and (= i l) (= j (- m 1))) (= k n))))
                    (or (and (and (= i (+ l 1)) (= j m)) (= k n))
                    (and (and (= i (- l 1)) (= j m)) (= k n))))
                      (when (and (/= (aref cube i j k) -1.0) (/= (aref cube l m n) -1.0))
                        (setf change (* (- (aref cube i j k) (aref cube l m n) ) DTerm))
                        (decf (aref cube i j k) change)
                        (incf (aref cube l m n)  change)))))))))

;;Setting the time variable
(incf time_var timestep)

;;Initializing more variables
(setf minval (aref cube 0 0 0))
(setf maxval (aref cube 0 0 0))

;;Calculating out the min and max values
(loop for x from 0 to (- maxsize 1) do
  (loop for y from 0 to (- maxsize 1) do
    (loop for z from 0 to (- maxsize 1) do
      (when (/= (aref cube x y z) -1.0)
        (setf maxval (max maxval (aref cube x y z)))
        (setf minval (min minval (aref cube x y z)))
        (incf sumval (aref cube x y z))))))

;;Changing the ratio variable
(setf ratio_var (/ minval maxval))
 
;;Printing the variables 
(write ratio_var)
(princ "        ")
(write time_var)
(terpri)

)    ;;end of the while loop

(princ "Box equilibrated in ")
(write time_var)
(princ " seconds of simulation time")
(terpri)
)
