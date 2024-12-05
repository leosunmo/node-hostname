# Kind parameters
KIND_CLUSTER_NAME=node-hostname

# Docker parameters
DOCKER_IMAGE_NAME=node-hostname
# Docker tag based on timestamp
DOCKER_TS_TAG:=$(shell date +%Y%m%d%H%M%S)

run: packages
	node bin/www

packages:
	yarn install

docker-build-dev:
	docker build -t $(DOCKER_IMAGE_NAME):dev .

docker-run: docker-stop docker-build-dev
	docker run -d -p 3000:3000 $(DOCKER_IMAGE_NAME):dev

docker-stop:
	docker kill $(shell docker ps -q --filter ancestor=$(DOCKER_IMAGE_NAME):dev)

kind-up: check-kubectl check-kind kind-start kind-load-image kind-deploy

kind-start:
	kind get clusters | grep -q $(KIND_CLUSTER_NAME) || kind create cluster --name $(KIND_CLUSTER_NAME) --config dev/kind/kind-config.yaml
	kubectl config use-context kind-$(KIND_CLUSTER_NAME)
	kubectl apply -f dev/kind/manifests/ingress
	@echo "\nWaiting for the cluster and ingress to be ready..."
	kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s

docker-build-kube:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_TS_TAG) .
	sed -i "s|$(DOCKER_IMAGE_NAME):.*|$(DOCKER_IMAGE_NAME):$(DOCKER_TS_TAG)|g" dev/kube/hostname.deployment.yaml

kind-load-image: docker-build-kube
	kind load docker-image $(DOCKER_IMAGE_NAME):$(DOCKER_TS_TAG) --name $(KIND_CLUSTER_NAME)

kind-deploy:
	kubectl apply -f dev/kube
	@echo "========================================"
	@echo "Access Kind on the following IP address:"
	@echo http://$$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(KIND_CLUSTER_NAME)-control-plane)
	@echo "========================================"

kind-down:
	kind delete cluster --name $(KIND_CLUSTER_NAME)

check-kind:
	@which kind > /dev/null || (echo "kind is not installed. Please install it from https://kind.sigs.k8s.io/docs/user/quick-start/" && exit 1)

check-kubectl:
	@which kubectl > /dev/null || (echo "kubectl is not installed. Please install it from https://kubernetes.io/docs/tasks/tools/install-kubectl/" && exit 1)

.PHONY: run packages docker-build-dev docker-run docker-stop kind-up kind-start docker-build-kube kind-load-image kind-deploy kind-down check-kind check-kubectl