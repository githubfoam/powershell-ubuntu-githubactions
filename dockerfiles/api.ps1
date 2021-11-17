Import-Module Polaris

$data = @(
    @{Id="1";Name="Jamie"}
    @{Id="2";Name="Chuck"}
   )

New-PolarisRoute -Path "/api/people" -Method GET -Scriptblock {
    $Response.Json(($data | ConvertTo-Json))
} 

New-PolarisRoute -Path "/api/people/:id" -Method GET -Scriptblock {
    $person = $data | Where-Object { $_.Id -eq $Request.Parameters.id }
    $Response.Json(($person | ConvertTo-Json))
} 

# Start the server
$app = Start-Polaris -Port 8082 -MinRunspaces 1 -MaxRunspaces 5 -UseJsonBodyParserMiddleware -Verbose # all params are optional

while($app.Listener.IsListening){
    Wait-Event callbackcomplete
}
