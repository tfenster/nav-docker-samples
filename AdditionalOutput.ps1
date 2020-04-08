Write-Host "Send mail to $env:owner"
Write-Host "Admin Username      : $username"
Write-Host ("Admin Password      : "+[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)))