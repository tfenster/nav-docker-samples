# heavily based on https://github.com/microsoft/navcontainerhelper/issues/331

$WebClientFolder = (Get-Item "C:\Program Files\Microsoft Dynamics NAV\*\Web Client")[0]
$WebServerInstance = "bconly"
$ServerInstance = "BC"
$Server = "bconly"
$auth = "NavUserPassword"
$clientServicesPort = 7046
$ManagementServicesPort = 7045
$webClientPort = 80
$wwwRootPath = "c:\inetpub\wwwroot"

$certparam = @{}
$publishFolder = "$webClientFolder\WebPublish"

$NAVWebClientManagementModule = "$webClientFolder\Modules\NAVWebClientManagement\NAVWebClientManagement.psm1"
if (!(Test-Path $NAVWebClientManagementModule)) {
    $NAVWebClientManagementModule = "$webClientFolder\Scripts\NAVWebClientManagement.psm1"
}
Import-Module $NAVWebClientManagementModule
New-NAVWebServerInstance -PublishFolder $publishFolder `
                         -WebServerInstance "$WebServerInstance" `
                         -Server "$Server" `
                         -ServerInstance "$ServerInstance" `
                         -ClientServicesCredentialType $Auth `
                         -ClientServicesPort "$clientServicesPort" `
                         -WebSitePort $webClientPort @certparam

$navsettingsFile = Join-Path $wwwRootPath "$WebServerInstance\navsettings.json"
$config = Get-Content $navSettingsFile | ConvertFrom-Json
Add-Member -InputObject $config.NAVWebSettings -NotePropertyName "RequireSSL" -NotePropertyValue "true" -ErrorAction SilentlyContinue
$config.NAVWebSettings.RequireSSL = $false
Add-Member -InputObject $config.NAVWebSettings -NotePropertyName "PersonalizationEnabled" -NotePropertyValue "true" -ErrorAction SilentlyContinue
$config.NAVWebSettings.PersonalizationEnabled = $true
$config.NAVWebSettings.ManagementServicesPort = $ManagementServicesPort

Remove-NAVWebServerInstance BC
Stop-NAVServerInstance BC
Stop-Service 'MSSQL$SQLEXPRESS'