/* FIND movtrp.fatura-frete                                         */
/*      WHERE fatura-frete.nr-fatura   = "10033/73"                 */
/*        AND fatura-frete.cod-estabel = "19"                       */
/*        AND fatura-frete.serie       = ""                         */
/*        AND fatura-frete.cgc-transp  = '83298299000130' NO-ERROR. */

/* FIND movtrp.fatura-frete                                         */
/*      WHERE fatura-frete.nr-fatura   = "411792"                   */
/*        AND fatura-frete.cod-estabel = "19"                       */
/*        AND fatura-frete.serie       = "U1"                       */
/*        AND fatura-frete.cgc-transp  = '10820230000150' NO-ERROR. */

/* FIND movtrp.fatura-frete                                          */
/*      WHERE fatura-frete.nr-fatura   = "410260"                    */
/*        AND fatura-frete.cod-estabel = "19"                        */
/*        AND fatura-frete.serie       = "B2"                        */
/*        AND fatura-frete.cgc-transp  = '53640645000155' NO-ERROR.  */

/* FIND movtrp.fatura-frete                                          */
/*      WHERE fatura-frete.nr-fatura   = "409461"                    */
/*        AND fatura-frete.cod-estabel = "19"                        */
/*        AND fatura-frete.serie       = "B2"                        */
/*        AND fatura-frete.cgc-transp  = '53640645000155' NO-ERROR.  */

FOR EACH movtrp.fatura-frete                                        
     WHERE fatura-frete.nr-fatura   = "342"
       AND fatura-frete.cod-estabel = "26"
       AND fatura-frete.serie       = ""
       AND fatura-frete.cgc-transp  = "77088334000193".

MESSAGE fatura-frete.cod-estabel  SKIP 
        fatura-frete.cgc-transp   SKIP 
        fatura-frete.nr-fatura    SKIP 
        fatura-frete.serie        SKIP 
        fatura-frete.dt-emissao   SKIP(2)
        fatura-frete.dt-integr-ap SKIP 
        fatura-frete.hr-integr-ap SKIP
        fatura-frete.dt-integr-of SKIP
        fatura-frete.hr-integr-of SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
ASSIGN fatura-frete.dt-integr-ap  = ?
       fatura-frete.hr-integr-ap  = ?.

ASSIGN fatura-frete.dt-integr-ap  = DATE(01,26,2012)
       fatura-frete.hr-integr-ap  = '1251'.
*/
/*
ASSIGN fatura-frete.dt-integr-of = ?
       fatura-frete.hr-integr-of = ?.
*/
