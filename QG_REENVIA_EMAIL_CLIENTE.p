FOR EACH es-comunica-cliente-envio WHERE nr-pedcli = "3069-0609"
                                     AND es-comunica-cliente-envio.tipo = "EMAIL":

    DISP es-comunica-cliente-envio.data-envio
         es-comunica-cliente-envio.tipo.

    /*ASSIGN es-comunica-cliente-envio.data-envio = ?.*/
END.
