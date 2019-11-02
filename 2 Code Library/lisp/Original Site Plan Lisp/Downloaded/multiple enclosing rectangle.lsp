;Description:
;Bounding box alternative
;Arguments:
;settoenclose: a selection set to draw a box around
(defun multiple_enclosing_rectangle (settoenclose /
 active_document
 active_selectionset
 list_of_x_pt1
 list_of_y_pt1
 list_of_x_pt2
 list_of_y_pt2
 pt_1
 pt_2
 pt_3
 pt_4
 pt_txt_x
 pt_txt_y
 space
 sset
 vertices_list
 x_min
 x_max
 y_min
 y_max
 )

(setq active_document
  (vla-get-activedocument
   (vlax-get-acad-object)
   )
  )  

(setq sset settoenclose)
(if(not(null sset))
  (progn 
    (setq active_selectionset 
      (vla-get-activeselectionset active_document)
      )

    (vlax-for item active_selectionset
      (vlax-invoke-method
       item
       'GetBoundingBox
       'pt1
       'pt2
       )
      (setq list_of_x_pt1
        (cons
         (car (vlax-safearray->list pt1))
         list_of_x_pt1
         )
        )
      (setq list_of_y_pt1
        (cons
          (cadr (vlax-safearray->list pt1))
          list_of_y_pt1
          )
        )
      (setq list_of_x_pt2
        (cons
          (car (vlax-safearray->list pt2))
          list_of_x_pt2
          )
        )
      (setq list_of_y_pt2
        (cons
          (cadr (vlax-safearray->list pt2))
          list_of_y_pt2
          )
        )  
      )

    (setq x_min (apply 'min list_of_x_pt1))
    (setq y_min (apply 'min list_of_y_pt1))

    (setq x_max (apply 'max list_of_x_pt2))
    (setq y_max (apply 'max list_of_y_pt2))


    (setq pt_1 (list x_min y_min 0.0))
    (setq pt_2 (list x_max y_max 0.0))

    (setq pt_3 (list (car pt_2)(cadr pt_1) 0.0))
    (setq pt_4 (list (car pt_1)(cadr pt_2) 0.0))

    (setq vertices_list
      (apply
       'append
       (list pt_1 pt_3 pt_2 pt_4 pt_1)
       )
      )

    (setq pt_txt_x
      (mapcar '+ '(0.0 0.5 0.0)
        (mapcar '* '(0.5 0.5 0.5)
          (mapcar '+ pt_4 pt_2)))
      )

    (setq pt_txt_y
      (mapcar '+ '(-0.5 0.0 0.0)
        (mapcar '* '(0.5 0.5 0.5)
          (mapcar '+ pt_4 pt_1)))
      )

    (list pt_1 pt_2)
    )
  )
)

;Description:
;Command to run <a href="#multiple_enclosing_rectangle">multiple_enclosing_rectangle</a>.
(defun C:MER()(MULTIPLE_ENCLOSING_RECTANGLE (SSGET))(princ))