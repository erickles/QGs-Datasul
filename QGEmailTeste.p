DEFINE VARIABLE lSucesso AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cMessage AS CHARACTER   NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
/*ASSIGN vLocalHostName = STRING(param-global.serv-mail).*/

RUN H:\QGs\QGEmail.p(INPUT STRING(param-global.serv-mail),  /*  MailHUB         */
                     INPUT "erick.souza@tortuga.com.br",    /*  EmailTo         */
                     INPUT "erick.souza@tortuga.com.br",    /*  EmailFrom       */
                     INPUT "",                              /*  EmailCC         */
                     INPUT "Boletos.pdf",                   /*  Anexos          */
                     INPUT "C:\Temp\Boletos.pdf",           /*  Anexos Files    */
                     INPUT "BOLETO DSM",                    /*  Assunto         */
                     INPUT "Corpo",                         /*  Corpo           */
                     INPUT "",                              /*  MIME Header     */
                     INPUT "Text",                          /*  BodyType        */
                     INPUT 0,                               /*  Importance      */
                     INPUT NO,
                     INPUT "",
                     INPUT "",
                     INPUT "",
                     OUTPUT lSucesso,
                     OUTPUT cMessage).

MESSAGE lSucesso    SKIP
        cMessage
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
