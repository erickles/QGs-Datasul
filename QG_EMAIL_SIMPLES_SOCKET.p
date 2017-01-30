FIND FIRST param-global NO-LOCK NO-ERROR.

{include/i-smtprelay.i 1}

DEFINE VARIABLE vSmtpServer AS CHARACTER NO-UNDO 
                               FORMAT "X(50)"
                               LABEL "Smtp Server".

/*vSmtpServer = STRING(param-global.serv-mail).*/
vSmtpServer = c-servidor.

DEFINE VARIABLE vTo         AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "To" 
                               INITIAL "erick.souza@tortuga.com.br".

DEFINE VARIABLE vFrom       AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "From" 
                               INITIAL "erick.souza@tortuga.com.br".

DEFINE VARIABLE vSubject    AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "Subject" 

                               INITIAL "test email using Progress 4GL sockets".

DEFINE VARIABLE vBody       AS CHARACTER NO-UNDO
                               VIEW-AS EDITOR INNER-LINES 20 INNER-CHARS 70
                               SCROLLBAR-VERTICAL INITIAL "test email".

DEFINE VARIABLE vdebugmode  AS LOGICAL NO-UNDO
                               VIEW-AS TOGGLE-BOX.

DEFINE BUTTON bSend LABEL "Send".

DEFINE VARIABLE vbuffer AS MEMPTR  NO-UNDO.
DEFINE VARIABLE hSocket AS HANDLE  NO-UNDO.
DEFINE VARIABLE vstatus AS LOGICAL NO-UNDO.
DEFINE VARIABLE vState  AS INTEGER NO-UNDO.

/*
  Status:
        0 - No Connection to the server
        1 - Waiting for 220 connection to SMTP server
        2 - Waiting for 250 OK status to start sending email
        3 - Waiting for 250 OK status for sender
        4 - Waiting for 250 OK status for recipient
        5 - Waiting for 354 OK status to send data
        6 - Waiting for 250 OK status for message received
        7 - Quiting
*/

FORM
    vSmtpServer COLON 15 HELP "Enter the address of an smtpserver" SKIP
    vTo         COLON 15 HELP "Enter recipient's email address"    SKIP
    vFrom       COLON 15 HELP "Enter your email address"           SKIP
    vSubject    COLON 15 bSend SKIP
    vdebugmode  COLON 15 SKIP
    vBody       NO-LABEL
    WITH FRAME sendmail SIDE-LABEL WIDTH 80.

ON 'CHOOSE' OF bSend
    DO:
        ASSIGN vSmtpServer vTo vFrom vSubject vdebugmode vBody.
        RUN sendmail.
        RETURN.
    END.

DO ON ENDKEY UNDO, LEAVE:
    SESSION:APPL-ALERT-BOXES = YES.
    DISPLAY vSmtpServer vTo vFrom vSubject vdebugmode vBody WITH FRAME sendmail.
    ENABLE ALL WITH FRAME sendmail.
    WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
END.

PROCEDURE cleanup:
    hSocket:DISCONNECT() NO-ERROR.
    DELETE OBJECT hSocket NO-ERROR.
END.

PROCEDURE sendmail:
    CREATE SOCKET hSocket.
    hSocket:SET-READ-RESPONSE-PROCEDURE("readHandler", THIS-PROCEDURE).
    vstatus = hSocket:CONNECT("-S 25 -H " + vSmtpServer) NO-ERROR.
    IF NOT vstatus THEN 
        DO:
            MESSAGE "Server is unavailable".
            RETURN.
        END.
    vstate = 1.
    REPEAT ON STOP UNDO, LEAVE ON QUIT UNDO, LEAVE:
        IF vstate < 0 OR vstate = 7 THEN 
            LEAVE.
        WAIT-FOR READ-RESPONSE OF hSocket.
    END.
    RUN cleanup.
END PROCEDURE.

PROCEDURE newState:
    DEFINE INPUT PARAMETER newState AS INTEGER.
    DEFINE INPUT PARAMETER pstring  AS CHARACTER.

    IF vdebugmode THEN 
        MESSAGE "newState: " newState " pstring: " pstring VIEW-AS ALERT-BOX.
        vState = newState.
        IF pstring = "" THEN 
            RETURN.
        SET-SIZE(vbuffer) = LENGTH(pstring) + 1.
        PUT-STRING(vbuffer,1) = pstring.
        hSocket:WRITE(vbuffer, 1, LENGTH(pstring)).
        SET-SIZE(vbuffer) = 0.
END PROCEDURE.

PROCEDURE readHandler:
    DEFINE VARIABLE vlength AS INTEGER NO-UNDO.
    DEFINE VARIABLE str AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v AS INTEGER NO-UNDO.

    vlength = hSocket:GET-BYTES-AVAILABLE().
    IF vlength > 0 THEN
        DO:
            SET-SIZE(vbuffer) = vlength + 1.
            hSocket:READ(vbuffer, 1, vlength, 1).
            str = GET-STRING(vbuffer,1).
            IF vdebugmode THEN 
                MESSAGE "server:" str VIEW-AS ALERT-BOX.
            SET-SIZE(vbuffer) = 0.
            v = INTEGER(ENTRY(1, str," ")).
            CASE vState:
                WHEN 1 THEN 
                    IF v = 220 THEN
                        RUN newState(2, "HELO your.fully.qualified.domain.name.goes.here~r~n").
                    ELSE 
                        vState = -1.
                WHEN 2 THEN 
                    IF v = 250 THEN
                        RUN newState(3, "MAIL From: " + vFrom + "~r~n").
                    ELSE 
                        vState = -1.
                WHEN 3 THEN 
                    IF v = 250 THEN
                        RUN newState(4, "RCPT TO: " + vTo + "~r~n").
                    ELSE 
                        vState = -1.
                WHEN 4 THEN 
                    IF v = 250 THEN
                        RUN newState(5, "DATA ~r~n").
                    ELSE 
                        vState = -1.
                WHEN 5 THEN 
                    IF v = 354 THEN
                        RUN newState(6, "From: " + vFrom + "~r~n" + 
                                    "To: " + vTo + " ~r~n" +
                              "Subject: " + vSubject + 
                               " ~r~n~r~n" + 
                               vBody + "~r~n" + 
                               ".~r~n").
                    ELSE 
                        vState = -1.

                WHEN 6 THEN 
                    IF v = 250 THEN
                        RUN newState(7,"QUIT~r~n").
                    ELSE 
                        vState = -1.
            END CASE.
        END.
        IF vState = 7 THEN 
            MESSAGE "Email has been accepted for delivery.".
        IF vState < 0 THEN 
            MESSAGE "Email has been aborted".
END PROCEDURE.
