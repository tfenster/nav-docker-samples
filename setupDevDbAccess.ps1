# create sql user
$domain = $env:DevDomain
$AdGroup = $env:DevGroup

Write-Host " - Creating SQL user for $domain\$AdGroup"
$sqlcmd = @"
IF NOT EXISTS 
(SELECT name  
FROM master.sys.server_principals
WHERE name = '$domain\$AdGroup')
BEGIN
CREATE LOGIN [$domain\$AdGroup] FROM WINDOWS
EXEC sp_addsrvrolemember '$domain\$AdGroup', 'sysadmin'
END
"@
        
& sqlcmd.exe -Q $sqlcmd

Write-Host "FINISHED"