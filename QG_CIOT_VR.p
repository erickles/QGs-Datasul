DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH antt-viagem WHERE antt-viagem.antt-ciot-numero > 0
                       AND antt-viagem.data-partida >= 07/01/2016
                       AND antt-viagem.data-partida <= 07/31/2016
                       AND NOT antt-viagem.status-desc BEGINS "CANC"
                       NO-LOCK:
    iCont = iCont + 1.
END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
