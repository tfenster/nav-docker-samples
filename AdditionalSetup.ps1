$letsEncryptMail = $env:letsEncryptMail

mkdir c:\inetpub\wwwroot\eighty | Out-Null
new-website -name eighty -port 80 -physicalpath c:\inetpub\wwwroot\eighty 

Write-Host "Install modules and dependencies for LetsEncrypt"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Try
  {Install-Module -Name ACMESharp -Force -ErrorAction Stop}
Catch
  {
    Write-Host "Installing ACMESharp failed once, will retry"
    Start-Sleep -s 60
    Try
      {Install-Module -Name ACMESharp -Force -ErrorAction Stop}
    Catch
      {
        Write-Host "Installing ACMESharp failed twice, will retry"
        Start-Sleep -s 60
        Try
          {Install-Module -Name ACMESharp -Force -ErrorAction Stop}
        Catch
          {
            Write-Host "Installing ACMESharp failed three times, won't retry"
            exit 1
          }
      }
  }

Try
  {Install-Module -Name ACMESharp.Providers.IIS -Force -ErrorAction Stop}
Catch
  {
    Write-Host "Installing ACMESharp.Providers.IIS failed once, will retry"
    Start-Sleep -s 60
    Try
      {Install-Module -Name ACMESharp.Providers.IIS -Force -ErrorAction Stop}
    Catch
      {
        Write-Host "Installing ACMESharp.Providers.IIS failed twice, will retry"
        Start-Sleep -s 60
        Try
          {Install-Module -Name ACMESharp.Providers.IIS -Force -ErrorAction Stop}
        Catch
          {
            Write-Host "Installing ACMESharp.Providers.IIS failed three times, won't retry"
            exit 1
          }
      }
  }

Import-Module ACMESharp
Enable-ACMEExtensionModule -ModuleName ACMESharp.Providers.IIS

Write-Host "Register and complete challenge"
Initialize-ACMEVault
New-ACMERegistration -Contacts mailto:${letsEncryptMail} -AcceptTos
New-ACMEIdentifier -Dns $publicDnsName -Alias dns1
Complete-ACMEChallenge dns1 -ChallengeType http-01 -Handler iis -HandlerParameters @{ WebSiteRef = 'eighty' }

Submit-ACMEChallenge dns1 -ChallengeType http-01
sleep -s 60

Update-ACMEIdentifier dns1

Write-Host "Create certificate"
New-ACMECertificate dns1 -Generate -Alias cert1
Submit-ACMECertificate cert1
sleep -s 60

Update-ACMECertificate cert1
mkdir c:\cert | Out-Null
Get-ACMECertificate cert1 -ExportPkcs12 "c:\cert\cert1.pfx"

Write-Host "Import certificate"
$cert = Import-PfxCertificate -FilePath c:\cert\cert1.pfx -CertStoreLocation "cert:\localMachine\my"
$certThumb = $cert.Thumbprint

Write-Host "Add https binding with cert"
$guid = [guid]::NewGuid().ToString("B")
$hostnameport = $publicDnsName + ':443'
netsh http add sslcert hostnameport=$hostnameport certhash=$certThumb certstorename=My appid=$guid
New-WebBinding -name "NavWebApplicationContainer" -Protocol https -HostHeader $publicDnsName -Port 443 -SslFlags 1
