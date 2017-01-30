DEF VAR i AS INTE.
FOR EACH es-tab-preco-repres WHERE es-tab-preco-repres.nr-tabpre = "AC-18-M" 
                                OR es-tab-preco-repres.nr-tabpre = "AC-36-M " 
                                OR es-tab-preco-repres.nr-tabpre = "AL-18-P "                             
                                OR es-tab-preco-repres.nr-tabpre = "AL-36-P "
                                OR es-tab-preco-repres.nr-tabpre = "AP-C18R " 
                                OR es-tab-preco-repres.nr-tabpre = "AP-C36R "                        
                                OR es-tab-preco-repres.nr-tabpre = "BA1-C18R"
                                OR es-tab-preco-repres.nr-tabpre = "BA1-C36R"
                                OR es-tab-preco-repres.nr-tabpre = "BA2-C18R"
                                OR es-tab-preco-repres.nr-tabpre = "BA2-C36R"
                                OR es-tab-preco-repres.nr-tabpre = "BA3-C18R"
                                OR es-tab-preco-repres.nr-tabpre = "BA3-C36R"
                                OR es-tab-preco-repres.nr-tabpre = "BA4-C18R"
                                OR es-tab-preco-repres.nr-tabpre = "BA4-C36R"    
                                OR es-tab-preco-repres.nr-tabpre = "GO-C18R "
                                OR es-tab-preco-repres.nr-tabpre = "GO-C36R "
                                OR es-tab-preco-repres.nr-tabpre = "PA1-C18R"
                                OR es-tab-preco-repres.nr-tabpre = "PE-18-P "
                                OR es-tab-preco-repres.nr-tabpre = "PR-C36R "
                                OR es-tab-preco-repres.nr-tabpre = "RO3-18-M"
                                OR es-tab-preco-repres.nr-tabpre = "RO3-36-M"
                                OR es-tab-preco-repres.nr-tabpre = "SE-18-P"
                                OR es-tab-preco-repres.nr-tabpre = "TO-C18R" 
                                OR es-tab-preco-repres.nr-tabpre = "TO-C36R":                                             
    
    i = i + 1.
    DELETE es-tab-preco-repres.
END.

DISP i.
