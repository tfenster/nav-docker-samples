# invoke default
. (Join-Path $runPath $MyInvocation.MyCommand.Name)

# heavily inspired and with usage of https://github.com/waldo1001/BusinessCentralOpenAPIToolkit
try {
    # setup Waldo's Open API toolkit
    mkdir c:\openapi
    cd c:\openapi
    Invoke-WebRequest -Uri 'https://github.com/waldo1001/BusinessCentralOpenAPIToolkit/archive/refs/heads/main.zip' -UseBasicParsing -OutFile BusinessCentralOpenAPIToolkit.zip
    Expand-Archive .\BusinessCentralOpenAPIToolkit.zip -DestinationPath .
    cd .\BusinessCentralOpenAPIToolkit-main\
    remove-item -Recurse node_modules
    cd .\Microsoft.OpenApi.OData\
    Invoke-WebRequest -Uri 'https://www.nuget.org/api/v2/package/Microsoft.OpenApi.OData/1.0.8' -UseBasicParsing -OutFile Microsoft.OpenApi.OData.zip
    Expand-Archive .\Microsoft.OpenApi.OData.zip -DestinationPath .
    Move-Item .\lib\netstandard2.0\* . -Force
    cd ..

    # install choco, nodejs and express
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    refreshenv
    choco feature enable -n allowGlobalConfirmation
    choco install nodejs-lts
    refreshenv
    & 'C:\Program Files\nodejs\npm' install express swagger-ui-express yamljs

    # download data model
    $cred = New-Object System.Management.Automation.PSCredential($username, $securepassword)
    $BaseUrl = '$protocol$publicDnsName:7048/BC/api/v2.0'
    $Outfile = './MicrosoftAPIv2.0/MicrosoftAPIv2.0.edmx'
    $Metadataurl = $BaseUrl + '/$metadata?$schemaversion=2.0&tenant=default'
    Invoke-WebRequest -credential $cred -Uri $Metadataurl -OutFile $Outfile -UseBasicParsing

    # convert data model
    $folder = './MicrosoftAPIv2.0/'
    $Source = Get-ChildItem -Path $folder -Filter '*.edmx'
    $Dest = $folder + [io.path]::GetFileNameWithoutExtension($Source) + '.yaml'
    ./Microsoft.OpenApi.OData/OoasUtil.exe -y -i $Source.FullName -o $Dest 

    # start express with SwaggerUI frontend 
    start-job -ScriptBlock { cd 'C:\openapi\BusinessCentralOpenAPIToolkit-main'; & 'C:\Program Files\nodejs\node' .\MicrosoftAPIv2.0\MicrosoftAPIv2.0.js }
}
catch {
    "An error occurred that could not be resolved."
}