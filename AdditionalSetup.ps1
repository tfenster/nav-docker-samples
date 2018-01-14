. C:\Run\Prompt.ps1
New-NAVServerUser -WindowsAccount (whoami) NAV
New-NAVServerUserPermissionSet -WindowsAccount (whoami) -PermissionSetId SUPER NAV
Write-Host "initialize API Services"
Invoke-NAVCodeunit -CodeunitId 5465 -ServerInstance NAV -CompanyName (Get-NAVCompany NAV).CompanyName

$html = "<html><body><p>Username:$username<br />Password:"+[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))+'</p></body></html>'

$html | Set-Content C:\inetpub\wwwroot\http\accessdata.html