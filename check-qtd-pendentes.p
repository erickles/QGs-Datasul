INPUT FROM H:\bete\CarregaBuscaNatureza\Carga2.csv.

OUTPUT TO H:\bete\CarregaBuscaNatureza\ResultadoCarga1.txt.

DEF VAR seq-busca AS INTEGER NO-UNDO.
DEF VAR natoper-nota AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR cod-estabel AS CHAR FORMAT "x(3)" NO-UNDO.
DEF VAR natoper-frete AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-fretesimples AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-frete-simplesdiferUF AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-freteorigemUF AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-freteDiferUF AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-frete-servicoSP AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-frete-servicoforaSP AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR natoper-frete-servico AS CHAR FORMAT "x(6)" NO-UNDO.

ASSIGN seq-busca = 0.

REPEAT :

IMPORT DELIMITER ";" cod-estabel natoper-nota natoper-frete natoper-fretesimples natoper-freteorigemUF natoper-freteDiferUF natoper-frete-simplesdiferUF /*natoper-frete-servicoforaSP natoper-frete-servicoSP. */ natoper-frete-servico .


FIND LAST es-busca-natureza-frete NO-ERROR.
    IF AVAIL es-busca-natureza-frete THEN DO:
        ASSIGN seq-busca = es-busca-natureza-frete.seq-busca + 1.
    END.
    ELSE DO:
        ASSIGN seq-busca = 1.
        MESSAGE "passei"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.


/*    ASSIGN seq-busca = seq-busca + 1.*/


/*DISP seq-busca natoper-nota cod-estabel. /*natoper-frete natoper-fretesimples natoper-freteorigemUF natoper-freteDiferUF. */*/


    FIND FIRST es-busca-natureza-frete WHERE es-busca-natureza-frete.natoper-nota = natoper-nota NO-ERROR.
    IF NOT AVAIL es-busca-natureza-frete THEN DO:

        CREATE es-busca-natureza-frete.
        ASSIGN es-busca-natureza-frete.seq-busca = seq-busca
               es-busca-natureza-frete.natoper-nota = natoper-nota.

    END.

    FIND FIRST es-busca-natureza-frete WHERE es-busca-natureza-frete.natoper-nota = natoper-nota NO-ERROR.
    IF AVAIL es-busca-natureza-frete THEN DO:

        FIND FIRST es-busca-natureza-frete-movto WHERE es-busca-natureza-frete-movto.seq-busca = es-busca-natureza-frete.seq-busca
                                                   AND es-busca-natureza-frete-movto.cod-estabel = cod-estabel NO-ERROR.
            IF NOT AVAIL es-busca-natureza-frete-movto THEN DO:

                CREATE es-busca-natureza-frete-movto.
                ASSIGN es-busca-natureza-frete-movto.seq-busca                      =  es-busca-natureza-frete.seq-busca
                       es-busca-natureza-frete-movto.cod-estabel                    = cod-estabel
                       es-busca-natureza-frete-movto.natoper-frete                  = natoper-frete
                       es-busca-natureza-frete-movto.natoper-frete-simples          = natoper-fretesimples
                       es-busca-natureza-frete-movto.natoper-frete-origemUF         = natoper-freteorigemUF
                       es-busca-natureza-frete-movto.natoper-frete-diferUF          = natoper-freteDiferUF
                       es-busca-natureza-frete-movto.natoper-frete-simplesdiferUF   = natoper-frete-simplesdiferUF
/*                        es-busca-natureza-frete-movto.natoper-frete-servicoforaSP    = natoper-frete-servicoforaSP */
/*                        es-busca-natureza-frete-movto.natoper-frete-servicoSP        = natoper-frete-servicoSP.    */
                       es-busca-natureza-frete-movto.natoper-frete-servico          = natoper-frete-servico.
            END.

    END.

END.


