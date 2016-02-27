# docker-otp-chicago
Docker setup for a Chicago OpenTripPlanner instance

## How to setup (Mac OS X)
Clone the repo, cd into it
```
docker-machine create --driver virtualbox cta-otp
eval $(docker-machine env cta-otp)
docker build -t cta-otp
```

Then, after it finishes, run
`docker run -p 8080:8080 cta-otp --autoScan --server`

Now it should be running at `localhost:8080`

## How to setup (Linux)
Similar to the OSX instructions, but without the extra docker-machine steps at the beginning.
```
docker build -t cta-otp
docker run -p 8080:8080 cta-otp --autoScan --server
```
