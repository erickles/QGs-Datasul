                    DO i-contrato = 1 TO br-table:NUM-SELECTED-ROWS:

                       br-table:FETCH-SELECTED-ROW(i-contrato).

                       IF AVAIL antt-viagem THEN DO:


                           FIND FIRST bf-antt-viagem 
                               WHERE bf-antt-viagem.nr-embarque = antt-viagem.nr-embarque
                               AND   bf-antt-viagem.viagem-id   > antt-viagem.viagem-id   NO-LOCK NO-ERROR.

                           IF AVAIL bf-antt-viagem AND 
                                    bf-antt-viagem.status-desc <> "CANCELADA" THEN
                               ASSIGN l-erro = YES.

/*                                                                                                */
/*                            MESSAGE "i-contrato " i-contrato SKIP                               */
/*                                     "Row        " STRING(br-table:ROW) SKIP                    */
/*                                     "ROWID      " ROWID(antt-viagem) SKIP                      */
/*                                     "Linha Browse " br-table:FOCUSED-ROW SKIP                  */
/*                                     "Client ID  " STRING(antt-viagem.id-cliente)               */
/*                                 VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Linha Selecionada" .  */

                       END.
