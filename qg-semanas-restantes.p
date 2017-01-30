define var i-semanas-r as inte.

run pi-semanas-restantes(input today, output i-semanas-r).

disp i-semanas-r.


procedure pi-semanas-restantes:

    define input parameter d-data as date.
    define output parameter i-semanas as inte.

    define var semana1 as char.
    define var semana2 as char.
    define var semana3 as char.
    define var semana4 as char.
    define var semana5 as char.
    define var d-p-data as date.
    define var semana as inte.

    d-p-data = date(string("01" + string(month(d-data)) + string(year(d-data)))).

    /*Para meses com 31 dias*/
    if month(d-data) = 01 or 
       month(d-data) = 03 or
       month(d-data) = 05 or
       month(d-data) = 07 or
       month(d-data) = 08 or
       month(d-data) = 10 or
       month(d-data) = 12 then do:
        
        case weekday(d-p-data):
            when 1 then
                assign semana1 = "01,02,03,04,05,06,07"
                       semana2 = "08,09,10,11,12,13,14"
                       semana3 = "15,16,17,18,19,20,21"
                       semana4 = "22,23,24,25,26,27,28"
                       semana5 = "29,30,31".

            when 2 then
                assign semana1 =    "01,02,03,04,05,06"
                       semana2 = "07,08,09,10,11,12,13"
                       semana3 = "14,15,16,17,18,19,20"
                       semana4 = "21,22,23,24,25,26,27"
                       semana5 = "28,29,30,31".

            when 3 then
                assign semana1 =       "01,02,03,04,05"
                       semana2 = "06,07,08,09,10,11,12"
                       semana3 = "13,14,15,16,17,18,19"
                       semana4 = "20,21,22,23,24,25,26"
                       semana5 = "27,28,29,30,31".

            when 4 then
                assign semana1 =          "01,02,03,04"
                       semana2 = "05,06,07,08,09,10,11"
                       semana3 = "12,13,14,15,16,17,18"
                       semana4 = "19,20,21,22,23,24,25"
                       semana5 = "26,27,28,29,30,31".
            
            when 5 then
                assign semana1 =             "01,02,03"
                       semana2 = "04,05,06,07,08,09,10"
                       semana3 = "11,12,13,14,15,16,17"
                       semana4 = "18,19,20,21,22,23,24"
                       semana5 = "25,26,27,28,29,30,31".

            when 6 then
                assign semana1 =                "01,02"
                       semana2 = "03,04,05,06,07,08,09"
                       semana3 = "10,11,12,13,14,15,16"
                       semana4 = "17,18,19,20,21,22,23"
                       semana5 = "24,25,26,27,28,29,30".

            when 7 then
                assign semana1 =                   "01"
                       semana2 = "02,03,04,05,06,07,08"
                       semana3 = "09,10,11,12,13,14,15"
                       semana4 = "16,17,18,19,20,21,22"
                       semana5 = "23,24,25,26,27,28,29".
        end case.        

    end.

    /*Para meses com 30 dias*/
    if month(d-data) = 04 or 
       month(d-data) = 06 or
       month(d-data) = 09 or
       month(d-data) = 11 then do:

        case weekday(d-p-data):
            when 1 then
                assign semana1 = "01,02,03,04,05,06,07"
                       semana2 = "08,09,10,11,12,13,14"
                       semana3 = "15,16,17,18,19,20,21"
                       semana4 = "22,23,24,25,26,27,28"
                       semana5 = "29,30".

            when 2 then
                assign semana1 =    "01,02,03,04,05,06"
                       semana2 = "07,08,09,10,11,12,13"
                       semana3 = "14,15,16,17,18,19,20"
                       semana4 = "21,22,23,24,25,26,27"
                       semana5 = "28,29,30".

            when 3 then
                assign semana1 =       "01,02,03,04,05"
                       semana2 = "06,07,08,09,10,11,12"
                       semana3 = "13,14,15,16,17,18,19"
                       semana4 = "20,21,22,23,24,25,26"
                       semana5 = "27,28,29,30".

            when 4 then
                assign semana1 =          "01,02,03,04"
                       semana2 = "05,06,07,08,09,10,11"
                       semana3 = "12,13,14,15,16,17,18"
                       semana4 = "19,20,21,22,23,24,25"
                       semana5 = "26,27,28,29,30".
            
            when 5 then
                assign semana1 =             "01,02,03"
                       semana2 = "04,05,06,07,08,09,10"
                       semana3 = "11,12,13,14,15,16,17"
                       semana4 = "18,19,20,21,22,23,24"
                       semana5 = "25,26,27,28,29,30".

            when 6 then
                assign semana1 =                "01,02"
                       semana2 = "03,04,05,06,07,08,09"
                       semana3 = "10,11,12,13,14,15,16"
                       semana4 = "17,18,19,20,21,22,23"
                       semana5 = "24,25,26,27,28,29,30".

            when 7 then
                assign semana1 = "01"
                       semana2 = "02,03,04,05,06,07,08"
                       semana3 = "09,10,11,12,13,14,15"
                       semana4 = "16,17,18,19,20,21,22"
                       semana5 = "23,24,25,26,27,28,29".
        end case.

    end.

    /*Para Fevereiro*/
    if month(d-data) = 02 then do:

        case weekday(d-p-data):
            when 1 then
                assign semana1 = "01,02,03,04,05,06,07"
                       semana2 = "08,09,10,11,12,13,14"
                       semana3 = "15,16,17,18,19,20,21"
                       semana4 = "22,23,24,25,26,27,28"
                       semana5 = "".

            when 2 then
                assign semana1 =    "01,02,03,04,05,06"
                       semana2 = "07,08,09,10,11,12,13"
                       semana3 = "14,15,16,17,18,19,20"
                       semana4 = "21,22,23,24,25,26,27"
                       semana5 = "28".

            when 3 then
                assign semana1 =       "01,02,03,04,05"
                       semana2 = "06,07,08,09,10,11,12"
                       semana3 = "13,14,15,16,17,18,19"
                       semana4 = "20,21,22,23,24,25,26"
                       semana5 = "27,28".

            when 4 then
                assign semana1 =          "01,02,03,04"
                       semana2 = "05,06,07,08,09,10,11"
                       semana3 = "12,13,14,15,16,17,18"
                       semana4 = "19,20,21,22,23,24,25"
                       semana5 = "26,27,28".
            
            when 5 then
                assign semana1 =             "01,02,03"
                       semana2 = "04,05,06,07,08,09,10"
                       semana3 = "11,12,13,14,15,16,17"
                       semana4 = "18,19,20,21,22,23,24"
                       semana5 = "25,26,27,28".

            when 6 then
                assign semana1 =                "01,02"
                       semana2 = "03,04,05,06,07,08,09"
                       semana3 = "10,11,12,13,14,15,16"
                       semana4 = "17,18,19,20,21,22,23"
                       semana5 = "24,25,26,27,28".

            when 7 then
                assign semana1 = "01"
                       semana2 = "02,03,04,05,06,07,08"
                       semana3 = "09,10,11,12,13,14,15"
                       semana4 = "16,17,18,19,20,21,22"
                       semana5 = "23,24,25,26,27,28".
        end case.

    end.

    disp semana1 format "x(20)" skip
         semana2 format "x(20)" skip
         semana3 format "x(20)" skip
         semana4 format "x(20)" skip
         semana5 format "x(20)" skip.

    if index(semana1,string(day(d-data),"99")) <> 0 then
        semana = 1.

    if index(semana2,string(day(d-data),"99")) <> 0 then
        semana = 2.

    if index(semana3,string(day(d-data),"99")) <> 0 then
        semana = 3.

    if index(semana4,string(day(d-data),"99")) <> 0 then
        semana = 4.

    if index(semana5,string(day(d-data),"99")) <> 0 then
        semana = 5.

    i-semanas = 5 - semana + 1.

end procedure.
