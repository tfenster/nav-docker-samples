# nav-docker-samples
Samples for NAV on Docker usage

## Simple volume persistence
With this sample you can move a database inside a NAV container to a volume on the first run and re-attach it on consecutive runs. For it to work you need to provide an env param called "volPath" with the path inside the container to use and that path needs to be mapped to a volume. As the first run will create a subfolder named as the database, you'll need to provide that subfolder. Also, as you probably will want to reuse the users as well, provide the same username and password for all runs. Here is an example:

#### First run
```docker run -e accept_eula=y -e username=admin -e password=SuperSecret1 -e volPath=c:\databases_vol -e folders="c:\run\my=https://github.com/tfenster/nav-docker-samples/archive/simple-volume-persistence.zip\nav-docker-samples-simple-volume-persistence" -v C:\data\databases:c:\databases_vol microsoft/dynamics-nav:2018-rtm```

Afterwards you will see a subfolder CRONUS on your host's c:\data\databases folder containing the database files. Try e.g. to post an invoice or make any other change in the database. Then you can stop and remove the container.

#### Subsequent runs
```docker run -e accept_eula=y -e username=admin -e password=SuperSecret1 -e volPath=c:\databases_vol -e folders="c:\run\my=https://github.com/tfenster/nav-docker-samples/archive/simple-volume-persistence.zip\nav-docker-samples-simple-volume-persistence" -v C:\data\databases\CRONUS:c:\databases_vol microsoft/dynamics-nav:2018-cu1```

If you log back in, you will see that your changes from the first run are still there. As you can see, in the first run the image is 2018-rtm and in the second one it is 2018-cu1, so it doesn't need to be the same image.