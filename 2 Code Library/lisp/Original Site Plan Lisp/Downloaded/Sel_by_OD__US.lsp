 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;; Minimum Translation by Patrice 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Beautiful Routine from Bruno V.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; ---- Version de Sel_by_OD sur cadxp.com --- 
;; 
;; Je reviens sur ce sujet car à ce jour j'avais besoin d'un outil 
;; N'étant jamais mieux servi que par soi-même, je me suis pencher sur un code de filtrage sur OD 
;; 
;; Je le livre en version bêta si cela intéresse d'autre personnes pour effectuer des tests 
;; http://cadxp.com/index.php?/topic/26836-filtre-sur-des-objects-data/page__pid__187698 
;; 
;; par Bruno vs 1.01 BETA - Avec correction du bug sur Entite avec de multiples tables OD 
;; 
;; 
;; ---- Version de Sel_by_OD sur georezo.net --- 
;;
;; Je m'adresse particulièrement à Olivier dont j'ai pas mal utilisé 
;; sa routine MQSELECT ces dernier temps pour corriger des OD.
;; 
;; J'ai rencontré un petit souci qui m'a fort gêné. Ce que je voulais réaliser était de sélectionner des OD 
;; qui avaient un nom avec un espace à la fin. Exemple de donnée valide "TOTO", donnée non valide "TOTO ", 
;; afin de supprimer cet espace et ainsi d'avoir mes données cohérentes. 
;; 
;; Ta routine n'arrive pas a différencier ce type de données, elle sélectionne l'ensemble. 
;; 
;; D'autre part il est impossible d'utiliser des caractères joker comme ? ou * 
;; Te serait-il possible d'améliorer ceci ?
;; 
;; Pour ma part j'ai réussi à me dépanner avec ma routine en lisp, bien qu'elle ait bien fonctionné, 
;; la tienne a une exécution plus rapide, donc j'utilise plus volontiers MQSELECT.
;;
;; J'en profite pour livrer le code que je me suis fais pour les OD ...
;; 
;; --- Version livree sur Georezo.net --- Par Bruno le 21/01/2013 --- 
;; 

(defun C:SEL_BY_OD ( / js dxf_model all_fldnamelist all_fldtypelist all_vallist tbllist tbldef tblstr
                       fldnamelist fldtypelist fldnme fldtyp numrec ct cttemp vallist typ val nl
                       tmp_file dcl_file dcl_id indx Id_tbl Id_nam Id_val op_log what_next js_sel n) 

  (princ "\nPlease select an Entity with Object Data ")
  (while
    (null
      (setq js
        (ssget "_+.:E:S:L:N" 
          (list
            (cons 0 "*")
            (cons 67 (if (eq (getvar "CVPORT") 2) 0 1))
            (cons 410 (if (eq (getvar "CVPORT") 2) "Model" (getvar "CTAB")))
          )
        )
      )
    )
  )
  (setq dxf_model (entget (ssname js 0)) all_fldnamelist () all_fldtypelist () all_vallist ())
  (if (null (setq tbllist (ade_odgettables (cdar dxf_model)))) 

;   (princ "\nL'objet séléctionné ne contient pas de données d'objet.") 
    (princ "\nSelected Entity without any Object Data ") 

    (foreach tbl (reverse tbllist)
      (setq
        tbldef (ade_odtabledefn tbl)
        tblstr (cdr (nth 2 tbldef))
        fldnamelist ()
        fldtypelist ()
      )
      (foreach fld tblstr
        (setq
          fldnme (cdr (nth 0 fld))
          fldtyp (cdr (nth 2 fld))
          fldnamelist (append fldnamelist (list fldnme))
          fldtypelist (append fldtypelist (list fldtyp))
        )
      )
      (setq
        numrec (ade_odrecordqty (cdar dxf_model) tbl)
        ct 0
        all_fldnamelist (cons fldnamelist all_fldnamelist)
        all_fldtypelist (cons fldtypelist all_fldtypelist)
      )
      (while (< ct numrec)
        (setq cttemp 0 vallist ())
        (foreach fld fldnamelist
          (setq
            typ (nth cttemp fldtypelist)
            cttemp (+ cttemp 1)
            val (ade_odgetfield (cdar dxf_model) tbl fld ct)
          )
          (if (= typ "Integer")(setq val (fix val)))
          (setq vallist (append vallist (list val)))
        )
        (setq ct (+ ct 1))
      )
      (setq all_vallist (cons vallist all_vallist))
    )
  )
  (cond
    ((and tbllist all_fldnamelist all_fldtypelist all_vallist)
      (setq
        tmp_file (vl-filename-mktemp "sel_by_od.dcl")
        dcl_file (open tmp_file "w")
      )
      (write-line
        "Sel_By_OD : dialog {
          label = \"Fields to filter\";
            :column {
              label = \"Application\";
              :popup_list {key=\"tbl\";edit_width=25;}
              }
            :column {
              label = \"Object Data\";
              :popup_list {key=\"nam\";edit_width=25;}
              :edit_box {
                label = \"Filed Value:\";
                mnemonic = \"V\";
                key = \"val\";
                edit_width = 15;
                edit_limit = 31;
                }
              }
              :boxed_row {
                label = \"Logical Operator\";
                :radio_button {
                  label = \"=\";
                  key = \"b_equ\";
                }
                :radio_button {
                  label = \"/=\";
                  key = \"b_dif\";
                }
                :radio_button {
                  label = \">\";
                  key = \"b_sup\";
                }
                :radio_button {
                  label = \"<\";
                  key = \"b_inf\";
                }
                :radio_button {
                  label = \">=\";
                  key = \"b_sup-eq\";
                }
                :radio_button {
                  label = \"<=\";
                  key = \"b_inf-eq\";
                }
              }
            ok_cancel_err;
          }"
        dcl_file
      )
      (close dcl_file)
      (setq dcl_id (load_dialog tmp_file) indx (1- (length tbllist)) Id_tbl (nth indx tbllist) Id_nam (car (nth indx all_fldnamelist)) Id_val (car (nth indx all_vallist)) op_log "=")
      (setq what_next 2)
      (while (< 1 what_next)
        (if (not (new_dialog "Sel_By_OD" dcl_id)) (exit))
        (start_list "tbl")
        (mapcar 'add_list tbllist)
        (end_list)
        (set_tile "tbl" (itoa indx))
        (start_list "nam")
        (mapcar 'add_list (nth indx all_fldnamelist))
        (end_list)
        (set_tile "nam" (itoa (- (length (nth indx all_fldnamelist)) (length (member (car (nth indx all_fldnamelist)) (nth indx all_fldnamelist))))))
        (set_tile "val"
          (setq Id_val
            (car
              (mapcar
                '(lambda (x)
                  (cond
                    ((eq (type x) 'REAL) (rtos x))
                    ((eq (type x) 'INT) (itoa x))
                    ((eq (type x) 'LIST) (apply 'strcat (mapcar 'strcat (mapcar 'rtos x)'("," "," ""))))
                    (T x)
                  )
                )
                (nth indx all_vallist)
              )
            )
          )
        )
        (cond
          ((= op_log "=") (set_tile "b_equ" "1") (mode_tile "b_equ" 2))
          ((= op_log "/=") (set_tile "b_dif" "1") (mode_tile "b_dif" 2))
          ((= op_log ">") (set_tile "b_sup" "1") (mode_tile "b_sup" 2))
          ((= op_log "<") (set_tile "b_inf" "1") (mode_tile "b_inf" 2))
          ((= op_log ">=") (set_tile "b_sup-eq" "1") (mode_tile "b_sup-eq" 2))
          ((= op_log "<=") (set_tile "b_inf-eq" "1") (mode_tile "b_inf-eq" 2))
        )
        (set_tile "error" "")
        (action_tile "tbl" "(setq Id_tbl (nth (setq indx (fix (atof (get_tile \"tbl\")))) tbllist))
        (start_list \"nam\")
        (mapcar 'add_list (nth indx all_fldnamelist))
        (end_list)
        (set_tile \"nam\" (setq Id_nam (nth (- (length (nth indx all_fldnamelist)) (length (member (car (nth indx all_fldnamelist)) (nth indx all_fldnamelist)))) (nth indx all_fldnamelist))))
        (set_tile \"val\"
          (setq Id_val
            (car
              (mapcar
                '(lambda (x)
                  (cond
                    ((eq (type x) 'REAL) (rtos x))
                    ((eq (type x) 'INT) (itoa x))
                    ((eq (type x) 'LIST) (apply 'strcat (mapcar 'strcat (mapcar 'rtos x)'(\",\" \",\" \"\"))))
                    (T x)
                  )
                )
                (nth indx all_vallist)
              )
            )
          )
        )
        ")
        (action_tile "nam" "(setq Id_nam (nth (fix (atof (get_tile \"nam\"))) (nth indx all_fldnamelist)))
        (set_tile \"val\"
          (setq Id_val 
            (nth (vl-position Id_nam (nth indx all_fldnamelist))
              (mapcar
                '(lambda (x)
                  (cond
                    ((eq (type x) 'REAL) (rtos x))
                    ((eq (type x) 'INT) (itoa x))
                    ((eq (type x) 'LIST) (apply 'strcat (mapcar 'strcat (mapcar 'rtos x)'(\",\" \",\" \"\"))))
                    (T x)
                  )
                )
                (nth indx all_vallist)
              )
            )
          )
        )
        ")
        (action_tile "val" "(setq Id_val $value)")
        (action_tile "b_equ" "(setq op_log \"=\")")
        (action_tile "b_dif" "(setq op_log \"/=\")")
        (action_tile "b_sup" "(setq op_log \">\")")
        (action_tile "b_inf" "(setq op_log \"<\")")
        (action_tile "b_sup-eq" "(setq op_log \">=\")")
        (action_tile "b_inf-eq" "(setq op_log \"<=\")")
        (action_tile "accept" "(done_dialog 1)")
        (action_tile "cancel" "(done_dialog 0)")
        (setq what_next (start_dialog))
      )
      (unload_dialog dcl_id)
      (vl-file-delete tmp_file)
      (setq typ (nth (- (length (nth indx all_fldnamelist)) (length (member id_nam (nth indx all_fldnamelist)))) (nth indx all_fldtypelist)) nl nil)
      (cond
        ((eq typ "Real") (setq Id_val (atof Id_val)))
        ((eq typ "Integer") (setq Id_val (atoi Id_val)))
        ((eq typ "Point") (setq Id_val (read (vl-list->string (append (cons 40 (foreach n (reverse (vl-string->list id_val)) (setq nl (cons (if (eq n 44) 32 n) nl)))) '(41))))))
      )
      (setq js
        (ssget "_X"
          (list
            (assoc 0 dxf_model)
            (assoc 8 dxf_model)
            (if (assoc 6 dxf_model) (assoc 6 dxf_model) '(6 . "BYLAYER"))
            (if (assoc 62 dxf_model) (assoc 62 dxf_model) '(62 . 256))
            (if (assoc 48 dxf_model) (assoc 48 dxf_model) '(48 . 1))
            (cons 67 (if (eq (getvar "CVPORT") 1) 1 0))
            (cons 410 (if (eq (getvar "CVPORT") 1) (getvar "CTAB") "Model"))
          )
        )
        js_sel (ssadd)
      )
      (cond
        (js
          (repeat (setq n (sslength js))
            (if (not (null (setq tbllist (ade_odgettables (setq ent (ssname js (setq n (1- n))))))))
              (foreach tbl tbllist
                (setq
                  tbldef (ade_odtabledefn tbl)
                  tblstr (cdr (nth 2 tbldef))
                  fldnamelist ()
                  fldtypelist ()
                )
                (foreach fld tblstr
                  (setq
                    fldnme (cdr (nth 0 fld))
                    fldtyp (cdr (nth 2 fld))
                    fldnamelist (append fldnamelist (list fldnme))
                    fldtypelist (append fldtypelist (list fldtyp))
                  )
                )
                (setq numrec (ade_odrecordqty ent tbl) ct 0)
                (while (< ct numrec)
                  (setq cttemp 0)
                  (foreach fld fldnamelist
                    (setq
                      typ (nth cttemp fldtypelist)
                      cttemp (+ cttemp 1)
                      val (ade_odgetfield ent tbl fld ct)
                    )
                    (if (= typ "Integer")(setq val (fix val)))
                    (if
                      (and
                        (eq tbl Id_tbl)
                        (eq fld Id_nam)
                        (if (= typ "Character")
                          (wcmatch val Id_val)
                          (if (= typ "Point")
                            (mapcar '(lambda (u v) (eval (read op_log)) u v) val Id_val)
                            ((eval (read op_log)) val Id_val)
                          )
                        )
                      )
                      (setq js_sel (ssadd ent js_sel))
                    )
                  )
                  (setq ct (+ ct 1))
                )
              )
            )
          )
        )
      )
    )
  )
  (princ (strcat "\n" (itoa (sslength js_sel)) " trouvé(s)"))
  (sssetfirst nil js_sel)
  (prin1)
) 


