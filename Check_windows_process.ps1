$FIRMA = "JUSTMAR"
$MAIL = "biuro@tmask.pl"
$SEM = "services.sem"
$SLACKCH = "softera"
$D = $(Get-Date -Format "dddd MM/dd/yyyy HH:mm")


$list = get-content "services.txt"

foreach ($service in $list) {

if ((Get-Service -Name $service).Status -EQ "Running") {

    Write-Host "0 ""Check Production Service"" - OK Service $service running"
}

else {

    Write-Host "2 ""Check Production Service"" - ERROR Service $service not running"
    # curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACKCH\", \"username\": \"$FIRMA \", \"text\": \"ERROR service - $s \", \"icon_emoji\": \":red_circle:\"}" $SLACK
    Write-EventLog -LogName "Application" -Source "TMaskPL" -EventID 3001 -EntryType Error -Message "$D - ERROR Service $service not running" -Category 1 -RawData 10,20
    exit 1

    }

}
