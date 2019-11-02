(defun delbylayer (layname / *error* adoc umark sset sslen)  
  (defun *error* (msg)
    (if umark (progn (vla-endundomark adoc)(setq umark nil)))
    (if (or (= msg "Function cancelled")(= msg "quit / exit abort"))
      (princ)
      (princ (strcat "\nError: " msg))
    )
  )
  
  (setq adoc (vla-get-activedocument (vlax-get-acad-object)))

  (cond
    ( (setq sset (ssget "_X" (list (cons 8 layname))))
      (setvar 'clayer "0")
      (progn (vla-startundomark adoc)(setq umark T))    
      (setq sslen
        (length
          (mapcar
            'entdel
            (setq sslst
              (vl-remove-if
                'listp
                (mapcar 'cadr (ssnamex sset))
              )
            )
          )
        )
      )
      (vla-purgeall adoc)
      (progn (vla-endundomark adoc)(setq umark nil))
      (princ (strcat "\nErased " (itoa sslen) " items."))
    )
    (T
      (if
        (vl-catch-all-error-p
          (vl-catch-all-apply
            'vla-item
            (list (vla-get-layers adoc) layname)
          )
        )
        (princ "\nNo such layer.")
        (princ "\nNo item on that layer.")
      )
    )
  )
  
  (princ)
)