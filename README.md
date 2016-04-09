# OpenTripPlanner Docker Install - Chicago
Docker setup for a Chicago OpenTripPlanner instance

Includes two Dockerfiles, one that includes Metra data (in `metra-cta-pace`), and
one without.

## How to setup (Mac OS X)
Clone the repo, cd into the directory of the Dockerfile you'd like to use, and run
```
docker-machine create -d virtualbox --virtualbox-memory 8192 chicago-otp
eval $(docker-machine env chicago-otp)
docker build -t chicago-otp .
```

### Note on Metra data
If you use the Metra Dockerfile, it will take 20-30 minutes to build mainly
because, in order to cover the full service area for the Metra, it has to download
OSM data for Illinois and Wisconsin, and then take only the areas serviced by Metra.

## Running the Docker Container
Then, after it finishes, first run `docker-machine ip chicago-otp` to get
the IP address for the container, and then run
`docker run -p 80:8080 chicago-otp --router chicago --server`

Now you should be able to access it in your browser at that IP address.

You can also run with the `--analyst` option to use OTP Analyst features, or run
without any optional arguments to see all available command line options.

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

**Example:** `docker run -v /host/machine/dir:/var/otp/scripting`

### Syncing Data
In your script file, if you refer to any synced data (i.e. a population data CSV
for transportation analysis), you'll need to refer to the full file path on the
Docker container and not your host machine.

**Example:** `otp.loadCSVPopulation("/Users/me/test.csv")` becomes `otp.loadCSVPopulation("/var/otp/scripting/test.csv")`

The output file will show up in your host machine at the location of the synced volume
as well as in the location in the container.

Here is a full example of running this command against the container:

`docker run -v /Users/me:/var/otp/scripting chicago-otp --router chicago --script /var/otp/scripting/script.py`
