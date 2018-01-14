# nav-docker-samples
Samples for NAV on Docker usage

## Initialize API
With this sample you can initialize the Connect API. This requires you to set a NAV Server config setting (ApiServicesEnabled=true) and make sure the initialization Codeunit runs. This happens in AdditionalSetup.ps1.

#### Example
```docker run -e accept_eula=y -e customNavSettings="ApiServicesEnabled=true" -e folders="c:\run\my=https://github.com/tfenster/nav-docker-samples/archive/initialize-api.zip\nav-docker-samples-initialize-api" microsoft/dynamics-nav:2018```

Afterwards you might want to use my (ALRunner VS Code extension)[https://marketplace.visualstudio.com/items?itemName=tfenster.alrunner] to create some sample code as described (here)[https://www.axians-infoma.de/navblog/quickstart-your-d365-nav-connect-api-usage/]