# docker-otp-chicago
Docker setup for a Chicago OpenTripPlanner instance

## How to setup (Mac OS X)
Clone the repo, cd into it
```
docker-machine create -d virtualbox --virtualbox-memory 8192 cta-otp
eval $(docker-machine env cta-otp)
docker build -t cta-otp .
```

Then, after it finishes, run
`docker run -p 8080:8080 cta-otp --autoScan --server`

You can also run with the `--analyst` option to use OTP Analyst features

Open a separate terminal window and run `docker-machine ls` to get the IP address for the container

Now you should be able to access it in your browser at `<INSERTIP>:8080`

## How to setup (Linux)
Similar to the OSX instructions, but without the extra docker-machine steps at the beginning.
```
docker build -t cta-otp .
docker run -p 8080:8080 cta-otp --autoScan --server
```
