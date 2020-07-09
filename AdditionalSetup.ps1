if (Test-Path C:\Run\Apps -PathType Container) {
    . c:\run\prompt.ps1
    Get-ChildItem -Path c:\Run\Apps -Filter *.app | ForEach-Object { 
        Write-Host "Publishing $($_.FullName) to server instance $serviceName"
        Publish-NAVApp -ServerInstance $serverInstance -Path "$($_.FullName)"
        Sync-NavApp -ServerInstance $serverInstance -Name "$($_.Name.Substring(0, $_.Name.Length - 4))"
        Install-NavApp -ServerInstance $serverInstance -Name "$($_.Name.Substring(0, $_.Name.Length - 4))"
    }
}

. (Join-Path $runPath $MyInvocation.MyCommand.Name)