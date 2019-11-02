;Test, ignore

(prompt "\nType TEST_DCL2 to run.....")
 
(defun C:TEST_DCL2 ( / dcl_id)
 
(setq dcl_id (load_dialog "test_dcl2.dcl"))
     (if (not (new_dialog "test_dcl2" dcl_id))
	 (exit)
     );if
 
(set_tile "name" "Enter Name Here")
(mode_tile "name" 2)
(action_tile "name" "(setq name $value)")
(action_tile "age" "(setq age $value)")
(action_tile "accept" "(val1)")
 
(start_dialog)
(unload_dialog dcl_id)
 
(alert (strcat "Your name is " name
               "\nand you are " age " years of age."))
 
(princ)
 
);defun
 
-----------------------
 
(defun val1 ()
 
(if (= (get_tile "name") "Enter Name Here")
	(progn
	   (set_tile "error" "You must enter a name!")
	   (mode_tile "name" 2)
	);progn
	(val2)
);if
 
);defun
 
-------------------
 
(defun val2 ()
 
(if (< (atoi (get_tile "age")) 1)
	(progn
	  (set_tile "error" "Invalid Age - Please Try Again!!")
	  (mode_tile "age" 2)
	);progn
	(done_dialog)
);if
 
);defun
 
(princ)