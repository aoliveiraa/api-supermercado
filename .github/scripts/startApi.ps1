param (
    [Parameter()]
    [string]$BasePath
)

$ErrorActionPreference = "Stop"

#start dotnet application
$dotnet = Start-Job -ScriptBlock {
   cd $using:BasePath\src\Supermercado.API\
   dotnet run
}

Start-Sleep -Seconds 10

Receive-Job $dotnet

#start server 
$server = Start-Job -ScriptBlock {
    cd $using:BasePath\opentest\server
    opentest server
}

Start-Sleep -Seconds 15

Receive-Job $server

#start actor 
$actor = Start-Job -ScriptBlock {
    cd $using:BasePath\opentest\actor-web
    opentest actor
}

Start-Sleep -Seconds 15

Receive-Job $actor

New-Item "$BasePath\test-results" -ItemType Directory
& opentest session create --template "Call API Template" --wait --out $BasePath\test-results\junit.xml

exit 0
