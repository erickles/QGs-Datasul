FOR EACH es-consulta WHERE nr-consulta = 49675.
    DISP es-consulta.cod-situacao
         es-consulta.usuario-alteracao
         es-consulta.usuario.

    UPDATE es-consulta.cod-situacao
           es-consulta.usuario-alteracao.
    
    FOR EACH es-consulta-hist OF es-consulta:
        DISP es-consulta-hist.ind-situacao.
        UPDATE es-consulta-hist.ind-situacao.
    END.

END.
