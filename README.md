# node-hostname

This is a simple NodeJS application that reports its hostname when a request is sent to it.

## Local development
To start node-hostname locally for development, run `make run`. This will start the code running locally using your local NodeJS installation.

Sometimes you might want to build a Docker container and test again that. To build a Docker image, run `make docker-build`.
To run it locally in the Docker container, run `make docker-run`.

When you're done and want to shut down the Docker container, run `make docker-stop`.

### Accessing the HTTP server locally
No matter the way you run the code locally, you can access it on port 3000.
For example:
```
curl http://localhost:3000
{"hostname":"957ae14bc041"}
```

## Local Kubernetes testing
For local Kubernetes testing we use [kind](https://kind.sigs.k8s.io/). This allows us to spin up a local Kubernetes cluster inside a Docker container.
This is great for testing Kubernetes manifests and Helm charts.

### Start the local Kind cluster
To start a local Kubernetes cluster with an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), run `make kind-up`.
Once up, the IP address you can access the node-hostname service on will be printed to the console.

### Rebuild and deploy the node-hostname service
To rebuild the Docker image and deploy the node-hostname service to the local Kubernetes cluster, run `make kind-deploy`.
Every time you run this command, a new Docker image will be built and automatically deployed to the local Kubernetes cluster.

### Stop the local Kind cluster
To stop the local Kubernetes cluster, run `make kind-down`.

## CI/CD
Continuous Integration is handled by Github Actions.
All the configuration is stored under the [.github/workflows](.github/workflows) directory.

Docker image pushing is handled by a Github Action that runs on every push to the `master` branch.
It builds a Docker image and pushes it to the Github Container Registry.