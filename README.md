# docker-otp-chicago
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

Jython is also added to classpath if you want to run scripts with the `--script` or
`--enableScriptingWebService` options

## How to setup (Linux)
Similar to the OSX instructions, but without the extra docker-machine steps at the beginning.
```
docker build -t chicago-otp .
docker run -p 80:8080 chicago-otp --router chicago --server
```
