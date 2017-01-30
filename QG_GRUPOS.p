{include\i-buffer.i}

OUTPUT TO "C:\tmp\acesso_fornec_financ.txt".

FOR EACH mgcad.grp_usuar WHERE mgcad.grp_usuar.cod_grp_usuar = "CR2" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "CR1" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "CS1" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "CT1" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "des" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "FC2" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "GV1" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "sup" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "TS1" 
                            OR mgcad.grp_usuar.cod_grp_usuar = "TS5" 
                            NO-LOCK:

    PUT UNFORM mgcad.grp_usuar.des_grp_usuar + ":" SKIP.

    FOR EACH mgcad.usuar_grp_usuar OF mgcad.grp_usuar NO-LOCK:
        FIND FIRST usuar_mestre OF mgcad.usuar_grp_usuar NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            IF NOT usuar_mestre.nom_usuario BEGINS "DESA" THEN
                PUT UNFORM usuar_mestre.nom_usuario SKIP.
        END.
    END.

    PUT SKIP(1).

END.

OUTPUT CLOSE.
