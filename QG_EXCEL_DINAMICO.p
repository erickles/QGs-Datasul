DEF TEMP-TABLE tt-subst
    field ttcod-estabel     like nota-fiscal.cod-estabel    
    field ttestabel-nome    as char format "x(20)"
    field ttnrnota          like nota-fiscal.nr-nota-fis   
    field ttserie           like nota-fiscal.serie
    field ttdt-emis         like nota-fiscal.dt-emis-nota
    field ttnat-oper        like nota-fiscal.nat-operacao    
    field ttcid-cif         like nota-fiscal.cidade-cif
    field ttc-natureza      as char format "x(20)"
    field tttr-est          like transporte.estado 
    field tt-cid-st         like transporte.cidade
    field ttcod-estabel-st  like es-nota-fiscal.cod-estabel-st
    field ttestabel-st-nome as char format "x(20)"
    field ttnrnota-st       like es-nota-fiscal.nr-nota-fis-st
    field ttserie-st        like es-nota-fiscal.serie-st.

DEFINE VARIABLE c-nome-arq-temp     AS CHARACTER NO-UNDO.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE  NO-UNDO.  
DEFINE VARIABLE chWorkbook          AS COM-HANDLE  NO-UNDO.  
DEFINE VARIABLE chWorksheet         AS COM-HANDLE  NO-UNDO. 

/*stream **********************************************************************/
DEFINE STREAM str-excel.

/* Form Definitions ***********************************************************/
FORM tt-subst.ttestabel-nome    FORMAT "X(15)" COLUMN-LABEL "Estabelecimento"                  
     tt-subst.ttnrnota          FORMAT "X(07)" COLUMN-LABEL "Num NF"                           
     tt-subst.ttserie           FORMAT "X(03)" COLUMN-LABEL "Ser NF"                           
     tt-subst.ttdt-emis                        COLUMN-LABEL "Data Emis"                        
     tt-subst.ttnat-oper        FORMAT "X(15)" COLUMN-LABEL "Nat. Oper."                       
     tt-subst.ttcid-cif         FORMAT "X(15)" COLUMN-LABEL "Cidade CIF"                           
     tt-subst.ttc-natureza      FORMAT "X(15)" COLUMN-LABEL "Natureza"                         
     tt-subst.tttr-est          FORMAT "X(03)" COLUMN-LABEL "UF Tr."                           
     tt-cid-st                  FORMAT "X(15)" COLUMN-LABEL "Cidade Trans."                           
     tt-subst.ttestabel-st-nome FORMAT "X(15)" COLUMN-LABEL "Estabelec. ST"                    
     tt-subst.ttnrnota-st       FORMAT "X(07)" COLUMN-LABEL "Num NF ST"                        
     tt-subst.ttserie-st        FORMAT "X(03)" COLUMN-LABEL "Ser NF ST"                    
     WITH DOWN WIDTH 162 NO-BOX STREAM-IO FRAME f-tit-132.

ASSIGN c-nome-arq-temp = "t:\estacao\spool\esof016" +
                         SUBSTRING(STRING(TODAY, "99999999"),5,4) + 
                         SUBSTRING(STRING(TODAY, "99999999"),3,2) +
                         SUBSTRING(STRING(TODAY, "99999999"),1,2) + "-" +
                         SUBSTRING(STRING(TIME, "HH:MM:SS"),1,2) +
                         SUBSTRING(STRING(TIME, "HH:MM:SS"),4,2) +
                         SUBSTRING(STRING(TIME, "HH:MM:SS"),7,2) + ".txt".

IF tt-param.destino = 4 THEN DO:
    OUTPUT STREAM str-excel TO value(c-nome-arq-temp).
END.
                        
FOR EACH tt-subst NO-LOCK:

    IF tt-param.destino = 4 THEN DO:
          put stream str-excel UNFORMATTED 
          tt-subst.ttestabel-nome      CHR(9)
          tt-subst.ttnrnota            CHR(9)
          tt-subst.ttserie             CHR(9) 
          tt-subst.ttdt-emis           CHR(9) 
          tt-subst.ttnat-oper          CHR(9)                
          tt-subst.ttcid-cif           CHR(9)     
          tt-subst.ttc-natureza        CHR(9)   
          tt-subst.tttr-est            CHR(9)
          tt-subst.tt-cid-st           chr(9)
          tt-subst.ttestabel-st-nome   CHR(9) 
          tt-subst.ttnrnota-st         CHR(9) 
          tt-subst.ttserie-st          skip.                              
    END.
        
END.

IF tt-param.destino = 4 THEN DO:
   OUTPUT STREAM str-excel CLOSE.
END.

if tt-param.destino = 4 then do:

    CREATE "Excel.Application" chExcelApplication.
    chExcelApplication:Visible = FALSE.
    chExcelApplication:Workbooks:OpenText(c-nome-arq-temp, , , , , , TRUE ).
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    chWorkSheet:rows("1:1"):Select().
    chExcelApplication:selection:INSERT(1).
    
    chWorkSheet:Columns("A"):ColumnWidth = 32.
    chWorkSheet:Columns("B"):ColumnWidth = 12.
    chWorkSheet:Columns("C"):ColumnWidth = 08.
    chWorkSheet:Columns("D"):ColumnWidth = 18.
    chWorkSheet:Columns("E"):ColumnWidth = 12.
    chWorkSheet:Columns("F"):ColumnWidth = 30.
    chWorkSheet:Columns("G"):ColumnWidth = 18.
    chWorkSheet:Columns("H"):ColumnWidth = 24.
    chWorkSheet:Columns("I"):ColumnWidth = 27.
    chWorkSheet:Columns("J"):ColumnWidth = 32.
    chWorkSheet:Columns("K"):ColumnWidth = 16.
    chWorkSheet:Columns("L"):ColumnWidth = 08.
    
    chWorkSheet:Range("A1:Z1"):Font:Bold = TRUE.
    chWorkSheet:Range("A1:Z1"):HorizontalAlignment = 3.
    
    chWorkSheet:Range("A1"):VALUE  = "ESTABELECIMENTO".
    chWorkSheet:Range("B1"):VALUE  = "NOTA FISCAL".
    chWorkSheet:Range("C1"):VALUE  = "SERIE".
    chWorkSheet:Range("D1"):VALUE  = "DATA DE EMISSAO".
    chWorkSheet:Range("E1"):VALUE  = "NATUREZA".
    chWorkSheet:Range("F1"):VALUE  = "CIDADE CIF".
    chWorkSheet:Range("G1"):VALUE  = "NATUREZA ST".
    chWorkSheet:Range("H1"):VALUE  = "UF DO TRANSPORTADOR".
    chWorkSheet:Range("I1"):VALUE  = "CIDADE DO TRANSPORTADOR".
    chWorkSheet:Range("J1"):VALUE  = "ESTABELECIMENTO ST".
    chWorkSheet:Range("K1"):VALUE  = "NOTA FISCAL ST".
    chWorkSheet:Range("L1"):VALUE  = "SERIE ST".
    
    chWorkSheet:Range("A2"):Select().
    chExcelApplication:ActiveWindow:FreezePanes = TRUE.
    
    chExcelApplication:Visible = TRUE.

    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorksheet.
    
END.
