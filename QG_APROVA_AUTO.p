DEFINE VARIABLE h_espd1015u             AS HANDLE   NO-UNDO.

/* Aprovacao de Pedidos */
IF NOT VALID-HANDLE(h_espd1015u) OR
    h_espd1015u:TYPE <> "PROCEDURE":U OR
    h_espd1015u:FILE-NAME <> "esp\espd1015u.p":U THEN DO:
    RUN esp\espd1015u.p PERSISTENT SET h_espd1015u.
END.

FOR EACH es-aprov-pedido WHERE es-aprov-pedido.nr-pedcli = "MKTA603/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA308/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3438/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1201/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA377/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3801/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA396/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3500/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2370/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2496/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2428/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1321/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1894/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2465/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1751/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1694/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2020/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3921/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2396/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA821/11" 
                            OR es-aprov-pedido.nr-pedcli = "MKTA1299/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2212/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2519/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1296/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3920/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA100/11" 
                            OR es-aprov-pedido.nr-pedcli = "MKTA1729/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1811/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3818/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1457/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1969/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3810/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2670/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1265/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA2263/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA1301/11"
                            OR es-aprov-pedido.nr-pedcli = "MKTA3342/11":

        RUN emptyRowErrors IN h_espd1015u.                              
        RUN setRecord      IN h_espd1015u (INPUT ROWID(es-aprov-pedido)).                               
                                
        RUN saveRecord IN h_espd1015u (INPUT "aprovar",                 
                                       INPUT 28,
                                       INPUT "Aprovacao automatica.", 
                                       INPUT '').    
    END.
