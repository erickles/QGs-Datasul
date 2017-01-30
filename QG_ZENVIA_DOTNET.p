USING System.*.
USING System.TEXT.*.
USING System.Net.*.
USING System.IO.*.

DEFINE VARIABLE req         AS WebRequest   NO-UNDO.
DEFINE VARIABLE postData    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE byteArray   AS BYTE[]         NO-UNDO.
/* Create a request using a URL that can receive a post. */
req = WebRequest:CREATE("https://private-anon-49e0e4850-zenviasms.apiary-proxy.com/services/send-sms").

/* Set the Method property of the request to POST */
req:METHOD = "POST".

/* Create POST data and convert it to a byte array */
postData = "from:Remetente&to:5511997402216&msg:Mensagem de teste&callbackOption:ALL&id:007".
byteArray = Encoding:UTF8:GetBytes(postData).

/*  */
