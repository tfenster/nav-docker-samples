if ($restartingInstance) {
    # Nothing to do

} else {
    $EncryptionKeyFile = Join-Path $myPath 'DynamicsNAV.key'
    $LockFileName = 'WaitForKey'
    $LockFile = Join-Path $myPath $LockFileName 
    if (!(Test-Path $EncryptionKeyFile -PathType Leaf)) {
        Write-Host "No encryption key"
        $rnd = (Get-Random -Maximum 50) * 100
        Write-Host "Waiting for $rnd milliseconds"
        Start-Sleep -Milliseconds $rnd
        if (!(Test-Path $LockFile -PathType Leaf)) {
            New-Item -Path $myPath -Name $LockFileName -ItemType 'file' | Out-Null
            Write-Host "Got the lock"

            # invoke default
            . (Join-Path $runPath $MyInvocation.MyCommand.Name)

            Remove-Item $LockFile
            Write-Host "Removed the lock"
        } else {
            do {
                Write-Host "Waiting to become unlocked"
                Start-Sleep -Seconds 10
            } while (Test-Path $LockFile -PathType Leaf)
            Write-Host "Unlocked"
            
            # invoke default
            . (Join-Path $runPath $MyInvocation.MyCommand.Name)
        }
    } else {
        Write-Host "Found an encryption key"
    }
}
