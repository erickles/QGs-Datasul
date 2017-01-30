/*   ESCF0008 Contas a Pagar / Tarefas / Registrar / Pagto Rps via ordem compra */

/*Ultima solicita‡Æo Geraldo em 05.out.06 - Vitorio*/
/*Ultima solicita‡Æo Erica em   02.jun.06 - Vitorio*/
/*Ultima solicita‡Æo Vicente    29.mar.07 - Vitorio*/
/*Ultima solcita‡Æo K.Tomaz     21.mai.07 - Vitorio*/
/*Ultima solcita‡Æo Geraldo FFF 20.nov.07 - Vitorio*/
/*Ultima solicitacao Fabricio   28.abr.08 - Vitorio/Rubens*/
/*Ultima solicitacao Fabricio   30.abr.08 - Rubens */
/*Ultima solicitacao Fabricio   23.jul.08 - Diogo */
/*Ultima solicitacao Fabricio   28.jul.08 - Diogo */
/*Ultima solicitacao Fabricio   29.jul.08 - Diogo */
/*Ultima solicitacao Roger      13.nov.08 - Rubens */
/*Ultima solicitacao Gilson L   02.jun.09 - Rubens */  
/*Ultima solicitacao Evandro    17.jun.09 - Rubens */  
/*Ultima solicitacao Fabricio   02.jun.09 - Rubens */  
/*Ultima solicitacao Fabricio   02.jun.09 - Rubens */  

/*   update prazo-compr.situacao  = 6
     UPDATE ordem-compra.situacao = 6 (recebida) 2 (confirmada).
     update pedido-compr.situacao = 2.    */


DO TRANSACTION:

   FIND FIRST pedido-compr
       WHERE pedido-compr.num-pedido = 240057
       NO-ERROR.

   IF AVAIL pedido-compr THEN DO:
       FOR EACH ordem-compra
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido AND
                 ordem-compra.numero-ordem = 98530000:
           FOR EACH prazo-compra OF ordem-compra:
               DISP ordem-compra.numero-ordem.
/* ALT.SALDO*/ update prazo-compr.situacao
                      prazo-compr.quant-receb
                      prazo-compr.quant-saldo WITH WIDTH 300. 
           END.
           UPDATE ordem-compra.situacao WITH WIDTH 300.
       END.
       UPDATE pedido-compr.situacao WITH WIDTH 300.
   END.
END.
