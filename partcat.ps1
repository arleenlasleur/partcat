$http = [System.Net.HttpListener]::new() 
$index64 = "base64 html variant here"

$http.Prefixes.Add("http://127.0.0.1:1995/")
$http.Start()

if ($http.IsListening) {
    write-host ">> Ready <<" -f 'red' -b 'yellow'
    write-host "To access frontend browse $($http.Prefixes)" -f 'white'
    write-host "JavaScript is required."
    write-host "To stop server close this window."
}

while ($http.IsListening) {
    $context = $http.GetContext()

    # index route
    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {
        [string]$html = Get-Content "cat.html" -Raw
##        [string]$html = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($index64))
        if(Test-Path -Path data.json) {
            [string]$json = Get-Content "data.json" -Raw
            $html = $html.replace('[["MCU","Atmega8","TQFP32","",2,4,4,15]]',$json)
        }
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close()
    }

    # save file route
    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -like '*?save*') {
        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()
        Set-Content -Path data.json -Value $FormContent
        # ok
        [string]$html = "0" 
        # write error
##        [string]$html = "1" 
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close()
    }
} 
