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

---

# Google Cloud Infrastructure & Terraform
The production Kubernetes environment is hosted on Google Cloud. We use Terraform to manage the infrastructure.

## Prerequisites
To keep tools at the correct version, we use [asdf](https://asdf-vm.com/). The `.tool-versions` file specifies the versions of the tools we use.
The following tools are required for this project:
- [Terraform](https://www.terraform.io/downloads.html)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

## Setup
1. Authenticate with Google Cloud SDK: `gcloud auth application-default login`
2. Change to the `terraform` directory: `cd terraform`
3. Initialize Terraform: `terraform init`

In order to communicate with Google Cloud, Terraform needs to be authenticated. This can be done with local credentials or a service account. We use local credentials for now.
Run `gcloud auth application-default login` to authenticate with Google Cloud. These credentials are stored locally and will automatically be used by Terraform.


4. Run a plan to verify that it all works. This will show you what Terraform will do: `terraform plan`

## Deploy



# TODOs
## Infrastructure
- [ ] Store Terraform code in a separate repository.
    - [ ] Use Terraform modules for reusable infrastructure components.
    - [ ] Use separate repositories for different environments, e.g. `terraform-prod`, `terraform-staging`, `terraform-dev`.
    - [ ] Investigate Terraform per project/product. Depends on Google Cloud project structure.
- [ ] Cover Google Cloud Project creation and management with Terraform (we assume the project already exists and billing is setup and enabled).
- [ ] Use remote state for Terraform, e.g. Google Cloud Storage.
- [ ] Use a service account for Terraform, not local `gcloud` credentials (https://cloud.google.com/docs/terraform/authentication).
- [ ] Upgrade and use latest Google Terraform providers. The Google Terraform module examples use older versions.

## Kubernetes
- [ ] Use private clusters and probably not autopilot (issues with some observability tools) in production.
- [ ] Store Kubernetes "system" manifests such as cert-manager and ingress controllers in a separate repository.
- [ ] Use Helm for deploying node-hostname.
- [ ] Use GitOps (Flux, ArgoCD) for deploying as much as possible to the Kubernetes cluster.
- [ ] Use cert-manager for managing certificates.

## Workloads
- [ ] Resource requirement adjustments for node-hostname.
