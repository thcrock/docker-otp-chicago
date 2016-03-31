# OpenTripPlanner Docker Install - Chicago
Docker setup for a Chicago OpenTripPlanner instance

Includes GTFS feeds from Metra, Pace, and CTA

## How to setup (Mac OS X)
Clone the repo, cd into it
```
docker-machine create -d virtualbox --virtualbox-memory 8192 chicago-otp
eval $(docker-machine env chicago-otp)
docker build -t chicago-otp .
```

Note that it will take 20-30 minutes the first time mainly because, in order to cover the full
service area for the Metra, it has to download OSM data for Illinois and Wisconsin,
and then take only the areas serviced by Metra.

Then, after it finishes, run
`docker run -p 80:8080 chicago-otp --router chicago --server`

You can also run with the `--analyst` option to use OTP Analyst features

Open a separate terminal window and run `docker-machine ip chicago-otp` to get the IP address for the container

Now you should be able to access it in your browser at that IP address.

## How to setup (Linux)
Similar to the OSX instructions, but without the extra docker-machine steps at the beginning.
```
docker build -t chicago-otp .
docker run -p 80:8080 chicago-otp --router chicago --server
```

## Scripting with Data Volumes

In order to sync data and scripts from your host machine to the Docker container
for the scripting API, you'll need to just add pick a directory on your host machine,
and sync it to `var/otp/scripting` on the container.

Jython has already been added to the classpath by default in the Dockerfile, so it
will be enabled for scripting through either the `--script` or
`--enableScriptingWebService` options.

Example: `docker run -v /host/machine/dir:/var/otp/scripting`

In your script file, if you refer to any synced data (i.e. a population data CSV
for transportation analysis), you'll need to refer to the full file path on the
Docker container and not your host machine.

So if you would run `otp.loadCSVPopulation("/Users/me/test.csv")` in a Jython script,
you would have to change this to `otp.loadCSVPopulation("/var/otp/scripting/test.csv")`.
The same goes for output files, which means that `testCsv.save("/Users/me/test_output.csv")`
would become `testCsv.save("/var/otp/scripting/test_output.csv")`.

The output file will show up in your host machine at the location of the synced volume
as well as in the location in the container.

Here is a full example of running this command against the container:

`docker run -v /Users/me:/var/otp/scripting chicago-otp --router chicago --script /var/otp/scripting/script.py`
