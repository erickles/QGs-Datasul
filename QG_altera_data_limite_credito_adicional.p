DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "c:\temp\emit_dt_lim_cred.csv".

PUT "cod_emit;data" SKIP.

FOR EACH emitente WHERE YEAR(emitente.dt-lim-cred) <> 9999 NO-LOCK:
    PUT emitente.cod-emitente   ";"
        emitente.dt-lim-cred    SKIP.
END.
OUTPUT CLOSE.

