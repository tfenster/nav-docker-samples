if ($restartingInstance) {
    # Nothing to do

} else {
    $keyPath = 'c:\key\'
    $MyEncryptionKeyFile = Join-Path $keyPath 'DynamicsNAV.key'
    $LockFileName = 'WaitForKey'
    $LockFile = Join-Path $keyPath $LockFileName 
    if (!(Test-Path $MyEncryptionKeyFile -PathType Leaf)) {
        Write-Host "No encryption key"
        $rnd = (Get-Random -Maximum 50) * 100
        Write-Host "Waiting for $rnd milliseconds"
        Start-Sleep -Milliseconds $rnd
        if (!(Test-Path $LockFile -PathType Leaf)) {
            New-Item -Path $keyPath -Name $LockFileName -ItemType 'file' | Out-Null
            Write-Host "Got the lock"

            # invoke default
            . (Join-Path $runPath $MyInvocation.MyCommand.Name)

            Copy-Item (Join-Path $myPath 'DynamicsNAV.key') $keyPath
            Remove-Item $LockFile
            Write-Host "Removed the lock"
        } else {
            do {
                Write-Host "Waiting to become unlocked"
                Start-Sleep -Seconds 10
            } while (Test-Path $LockFile -PathType Leaf)
            Write-Host "Unlocked"
            Copy-Item $MyEncryptionKeyFile $myPath
            
            # invoke default
            . (Join-Path $runPath $MyInvocation.MyCommand.Name)
        }
    } else {
        Write-Host "Found an encryption key"
        Copy-Item $MyEncryptionKeyFile $myPath
    }
}
