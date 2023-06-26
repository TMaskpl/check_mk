$D = $(Get-Date -Format "dddd MM/dd/yyyy HH:mm")
$E = "C:\ProgramData\checkmk\agent\local\error_services.txt"
$S = "C:\ProgramData\checkmk\agent\local\services.txt"

if (Test-Path $E ){    
    Remove-Item $E
    }

$list = get-content $S

foreach ($service in $list) {

if ((Get-Service -Name $service -erroraction 'silentlycontinue').Status -EQ "Running") {

    continue
}

else {

    echo $service > $E

    }
}

if (Test-Path $E) {    
    $s = $(cat $E)
    #echo $s
    }


if (!(Test-Path $E)) {
    
    Write-Host 0 '"Check Service"' - Service running OK

    }
else {

    Write-Host 2 '"Check Service"' - Service $s not running ERROR
    exit 1

    }
