DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE BUFFER bf_tit_acr FOR tit_acr.

/* ref 5658 */
FOR EACH tit_acr WHERE tit_acr.cod_estab       = "19"
                   AND tit_acr.cod_espec_docto = "DN"
                   AND tit_acr.cod_ser_docto   = ""
                   AND tit_acr.cod_tit_acr     = "23800392485"
                   AND tit_acr.cod_parcela     = "0a"
                   NO-LOCK:    

    /*
    DISP tit_acr.cdn_cliente 
         tit_acr.cdn_clien_matriz 
         tit_acr.cod_empresa 
         tit_acr.cod_espec_docto 
         tit_acr.cod_estab 
         tit_acr.cod_grp_clien 
         tit_acr.cod_parcela 
         tit_acr.cod_portador 
         tit_acr.cod_refer 
         tit_acr.cod_ser_docto 
         tit_acr.cod_tit_acr FORMAT "X(12)"
         tit_acr.nom_abrev 
         tit_acr.num_id_movto_cta_corren 
         tit_acr.num_id_movto_tit_acr_ult 
         tit_acr.num_id_tit_acr tit_acr.num_pessoa WITH 1 COL.
    */
    DISP tit_acr WITH WIDTH 300 1 COL.
    /*
    DISP tit_acr.num_id_movto_cta_corren
         tit_acr.cod_refer.
    */

END.



/* ref 2371501133 */
FOR EACH tit_acr WHERE tit_acr.cod_estab       = "01"
                   AND tit_acr.cod_espec_docto = "DN"
                   AND tit_acr.cod_ser_docto   = ""
                   AND tit_acr.cod_tit_acr     = "23800392485"
                   AND tit_acr.cod_parcela     = "01"
                   NO-LOCK:    

    DISP tit_acr.cdn_cliente 
         tit_acr.cdn_clien_matriz 
         tit_acr.cod_empresa 
         tit_acr.cod_espec_docto 
         tit_acr.cod_estab 
         tit_acr.cod_grp_clien 
         tit_acr.cod_parcela 
         tit_acr.cod_portador 
         tit_acr.cod_refer 
         tit_acr.cod_ser_docto 
         tit_acr.cod_tit_acr FORMAT "X(12)"
         tit_acr.nom_abrev 
         tit_acr.num_id_movto_cta_corren 
         tit_acr.num_id_movto_tit_acr_ult 
         tit_acr.num_id_tit_acr tit_acr.num_pessoa WITH 1 COL.

    /*DISP tit_acr.cod_refer.*/
    DISP tit_acr WITH WIDTH 300 1 COL.
    /*
    DISP tit_acr.num_id_movto_cta_corren
         tit_acr.cod_refer.
    */
    /*
    FOR EACH movto_tit_acr OF tit_acr NO-LOCK:
        DISP tit_acr.cdn_cliente.
        DISP movto_tit_acr WITH WIDTH 300 1 COL.
    END.
    */
END.

/* CRDP008 */
    
FOR EACH tit_acr WHERE tit_acr.cod_estab       = "19"
                   AND tit_acr.cod_espec_docto = "DP"
                   AND tit_acr.cod_ser_docto   = "4"
                   AND tit_acr.cod_tit_acr     = "0228184"
                   AND tit_acr.cod_parcela     = "01"
                   NO-LOCK:
        
    DISP tit_acr.cdn_cliente 
         tit_acr.cdn_clien_matriz 
         tit_acr.cod_empresa 
         tit_acr.cod_espec_docto 
         tit_acr.cod_estab 
         tit_acr.cod_grp_clien 
         tit_acr.cod_parcela 
         tit_acr.cod_portador 
         tit_acr.cod_refer 
         tit_acr.cod_ser_docto 
         tit_acr.cod_tit_acr FORMAT "X(12)"
         tit_acr.nom_abrev 
         tit_acr.num_id_movto_cta_corren 
         tit_acr.num_id_movto_tit_acr_ult 
         tit_acr.num_id_tit_acr 
         tit_acr.num_pessoa WITH 1 COL.
    
    /*DISP tit_acr.cod_refer.*/
    DISP tit_acr WITH WIDTH 300 1 COL.
    /*
    DISP tit_acr.num_id_movto_cta_corren
         tit_acr.cod_refer.
    */
    /*
    FOR EACH movto_tit_acr OF tit_acr NO-LOCK:
        DISP movto_tit_acr WITH WIDTH 300 1 COL.
    END.
    */
END.

