function GetCurencyFromNBU{
    param (
        [string]$curencyName,
        [string]$curentDateP
    )

    $apiUrl = "https://bank.gov.ua/NBU_Exchange/exchange_site?valcode="+$curencyName+"&date="+$curentDateP+"&json" # Example public 
    $response = Invoke-WebRequest -Uri $apiUrl -Method Get -UseBasicParsing #API request
    $responseContent = $response.Content # content from API
    $converted = $responseContent | ConvertFrom-Json
    Write-Output "Currency: $($converted[0].cc)"
    Write-Output "Rate: $($converted[0].rate)"
    Write-Output "Rate Per Unit: $($converted[0].rate_per_unit)"
    Write-Output ""
}


$curency = "USD"
$curentDate = Get-Date -Format "yyyyMMdd"
Write-Output ""
Write-Output "NBU rates on date: $(Get-Date -Format "dd.MM.yyyy")"
Write-Output ""
# Write-Output ($args.Length -eq 2)
# Write-Output ($args[0] -ieq "-rq")
# Write-Output ($rgs.Length -eq 2 -and $args[0] -ieq "-rq")

if($args.Length -gt 1)
{
    $index = 1;
    while($args.Length -gt $index -and "$($args[$index])" -notlike '--*' )
    {
        $curency = "$($args[$index])"
    
        GetCurencyFromNBU -curencyName $curency -curentDateP $curentDate

        $index = $index + 1;
    }
}
else
{
    GetCurencyFromNBU -curencyName $curency -curentDateP $curentDate
}

if($args.Length -gt 0 -and $args[$args.Length - 1] -eq '--p')
{
    Write-Host "Press any key to continue...";
    $key = [Console]::ReadKey($true);
}

#$apiUrl = "https://bank.gov.ua/NBU_Exchange/exchange_site?valcode="+$curency+"&date="+$curentDate+"&json" # Example public 
#$response = Invoke-WebRequest -Uri $apiUrl -Method Get -UseBasicParsing #API request
#$responseContent = $response.Content # content from API
# $responseContent | ConvertFrom-Json | ConvertTo-Json -Depth 100 # test line
#$converted = $responseContent | ConvertFrom-Json
#Write-Host $responseContent #test line 

#Write-Output "NBU rates"
#Write-Output "Currency: $($converted[0].cc)"
#Write-Output "Rate: $($converted[0].rate)"
#Write-Output "Rate Per Unit: $($converted[0].rate_per_unit)"
#Write-Output "On date: $($converted[0].calcdate)"