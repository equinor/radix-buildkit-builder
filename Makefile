ENVIRONMENT ?= dev
ACR ?= radix$(ENVIRONMENT)
CONTAINER_REGISTRY ?= $(ACR).azurecr.io
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
VERSION ?= dev
HASH := $(shell git rev-parse HEAD)
TAG := $(BRANCH)-$(HASH)

echo:
	@echo "ENVIRONMENT : " $(ENVIRONMENT)
	@echo "ACR : " $(ACR)
	@echo "CONTAINER_REGISTRY : " $(CONTAINER_REGISTRY)
	@echo "BRANCH : " $(BRANCH)
	@echo "VERSION : " $(VERSION)
	@echo "TAG : " $(TAG)

.PHONY: build-image
build-image:
	docker buildx build -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(VERSION) -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(BRANCH)-$(VERSION) -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(TAG) --platform linux/arm64,linux/amd64 -f Dockerfile .

.PHONY: push-image
push-image:
	az acr login --name $(ACR)
	docker buildx build -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(VERSION) -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(BRANCH)-$(VERSION) -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(TAG) --platform linux/arm64,linux/amd64 -f Dockerfile --push .
