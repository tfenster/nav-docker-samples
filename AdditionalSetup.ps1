if (Test-Path C:\Run\Apps -PathType Container) {
    . c:\run\prompt.ps1
    $fullInstance = (Get-NAVServerInstance).ServerInstance
    $serverInstance = $fullInstance.Substring($fullInstance.IndexOf('$') + 1)
    Get-ChildItem -Path c:\Run\Apps -Filter *.app | ForEach-Object { 
        Write-Host "Publishing $($_.FullName) to server instance $serverInstance"
        Publish-NAVApp -ServerInstance $serverInstance -Path "$($_.FullName)"
        Sync-NavApp -ServerInstance $serverInstance -Name "$($_.Name.Substring(0, $_.Name.Length - 4))"
        Install-NavApp -ServerInstance $serverInstance -Name "$($_.Name.Substring(0, $_.Name.Length - 4))"
    }
}