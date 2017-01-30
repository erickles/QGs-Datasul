{include/i-buffer.i}

OUTPUT TO "c:\temp\usu_aprov.csv".

PUT "Usuario"               ";"
    "Lim. Dias"             ";"
    "Lim. Desco"            ";"
    "Aprov Desc/Pror Dup"   ";"
    "Aprov altern"          ";"
    "Dat lim aprov altern"  SKIP.

FOR EACH es-usuario NO-LOCK WHERE es-usuario.int-1 > 0 :
    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-usuario.cod-usuario NO-LOCK NO-ERROR.    
    PUT usuar_mestre.nom_usuario            ";"
        es-usuario.int-1                    ";"
        es-usuario.dec-1                    ";"
        es-usuario.i-desc-prorroga-dupl     ";"
        SUBSTRI(es-usuario.char-2,11,1)  ";"
        IF SUBSTRI(es-usuario.char-2,11,1) = "S" THEN SUBSTRI(es-usuario.char-2,1,10) ELSE "" SKIP.
END.

OUTPUT CLOSE.
