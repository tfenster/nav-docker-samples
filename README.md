# nav-docker-samples
The idea of the samples in this repository is to change how the NAV Docker images work by just adding an env param which causes the container to download the given sample and put it in whichever folder you need. Check [my blog](https://www.axians-infoma.de/navblog/use-github-to-change-how-your-nav-on-docker-container-works/) to find out more

## grant-user-access
With this sample you can give a user group access to the database and create NAV super users for them. If that group was named e.g. ALL_DEVS and your domain is SUPER-COMPANY, you would use it like this:
```
-e folders="c:\run\my=https://github.com/tfenster/nav-docker-samples/archive/grant-user-access.zip\nav-docker-samples-grant-user-access" -e DevDomain=SUPER-COMPANY -e DevGroup=ALL_DEVS
```

All credit for this goes to [Markus Lippert](https://github.com/lippertmarkus)
