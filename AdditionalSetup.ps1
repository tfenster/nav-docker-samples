Write-Host "Running additional setup.."

Write-Host "Setting up DEV users in NAV"
. (Join-Path $myPath 'setupDevNavUsers.ps1')

Write-Host "Granting access to SQL-DB to DEV ActiveDirectory Group"
. (Join-Path $myPath 'setupDevDbAccess.ps1')