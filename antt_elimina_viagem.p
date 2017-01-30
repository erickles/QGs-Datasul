

    FOR EACH antt-viagem                 
       WHERE antt-viagem.nr-embarque = 475351
         AND ind-tp-contrato < 4
       /*WHERE antt-viagem.nr-fila          = 561257 */
         AND antt-viagem.antt-ciot-numero = 0: 
      
         
        DISPL antt-viagem.nr-embarque
              antt-viagem.ind-tp-contrato.
        
        FOR EACH antt-viagem-favorec         WHERE antt-viagem-favorec.id-cliente        = antt-viagem.id-cliente: DELETE antt-viagem-favorec.        END. 
        FOR EACH antt-viagem-favorec-docto   WHERE antt-viagem-favorec-docto.id-cliente  = antt-viagem.id-cliente: DELETE antt-viagem-favorec-docto.  END. 
        FOR EACH antt-viagem-favorec-cartao  WHERE antt-viagem-favorec-cartao.id-cliente = antt-viagem.id-cliente: DELETE antt-viagem-favorec-cartao. END. 
        FOR EACH antt-viagem-favorec-conta   WHERE antt-viagem-favorec-conta.id-cliente  = antt-viagem.id-cliente: DELETE antt-viagem-favorec-conta.  END. 
        FOR EACH antt-viagem-veiculo         WHERE antt-viagem-veiculo.id-cliente        = antt-viagem.id-cliente: DELETE antt-viagem-veiculo.        END. 
        FOR EACH antt-viagem-docto           WHERE antt-viagem-docto.id-cliente          = antt-viagem.id-cliente: DELETE antt-viagem-docto.          END. 
        FOR EACH antt-viagem-docto-compl     WHERE antt-viagem-docto-compl.id-cliente    = antt-viagem.id-cliente: DELETE antt-viagem-docto-compl.    END. 
        FOR EACH antt-viagem-docto-pessoa    WHERE antt-viagem-docto-pessoa.id-cliente   = antt-viagem.id-cliente: DELETE antt-viagem-docto-pessoa.   END. 
        FOR EACH antt-viagem-frete-item      WHERE antt-viagem-frete-item.id-cliente     = antt-viagem.id-cliente: DELETE antt-viagem-frete-item.     END. 
        FOR EACH antt-viagem-parcela         WHERE antt-viagem-parcela.id-cliente        = antt-viagem.id-cliente: DELETE antt-viagem-parcela.        END. 
        FOR EACH antt-viagem-ponto           WHERE antt-viagem-ponto.id-cliente          = antt-viagem.id-cliente: DELETE antt-viagem-ponto.          END. 
        FOR EACH antt-viagem-pedagio-praca   WHERE antt-viagem-pedagio-praca.id-cliente  = antt-viagem.id-cliente: DELETE antt-viagem-pedagio-praca.  END. 
        
        DELETE antt-viagem.        
        

        LEAVE.
           
END. 
