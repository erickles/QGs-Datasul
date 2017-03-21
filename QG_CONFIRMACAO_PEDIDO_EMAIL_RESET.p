FIND LAST es-comunica-cliente-envio WHERE es-comunica-cliente-envio.tipo        = "EMAIL"
                                      AND es-comunica-cliente-envio.data-envio  <> ?
                                      AND es-comunica-cliente-envio.nr-pedcli BEGINS "3076-"
                                      NO-ERROR.
ASSIGN es-comunica-cliente-envio.data-envio = ?.
