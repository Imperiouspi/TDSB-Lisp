;ignore. Test file to run commands through autocad. Does weird things when loaded!
(command "shell" "powershell.exe -ExecutionPolicy Bypass -File \"H:\\Map 3d\\2 Code Library\\ps1\\getname.ps1\"")
(while (not (findfile "H:\\tmp.txt")))
(setq f (open "H:\\tmp.txt" "r"))
(print (read-line f))
(close f)

(vl-file-delete "H:\\tmp.txt")

(setq wscript (vlax-create-object "WScript.Shell"))
(vlax-invoke-method wscript 'Run "powershell.exe -ExecutionPolicy Bypass -File \"H:\\Map 3d\\2 Code Library\\ps1\\getname.ps1\" waitOnReturn")
(print "done")