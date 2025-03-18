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

test:
	docker build -t $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(BRANCH)-$(VERSION) -f Dockerfile . ;
	docker run --privileged -v $$(pwd):/context -it --rm $(CONTAINER_REGISTRY)/radix-buildkit-builder:$(BRANCH)-$(VERSION) \
        --tag "test-deleteme" \
        --dockerfile "test.Dockerfile" \
        --context "/context" \
        --branch "" \
        --registry "radixdev.azurecr.io" \
		--registry-password "$$(az acr login --expose-token -n radixdev --query accessToken -o tsv)" \
		--registry-username "00000000-0000-0000-0000-000000000000" \
		--tag radixdev.azurecr.io/radix-buildkit-demo-test:test-deleteme \
		--cluster-type-tag  radixdev.azurecr.io/radix-buildkit-demo-test:development-deleteme	\
		--cluster-name-tag radixdev.azurecr.io/radix-buildkit-demo-test:weekly-12-deleteme \
		--cache-registry radixdevapp.azurecr.io \
		--cache-repository radixdevapp.azurecr.io/radix-buildkit-demo-test/cache \
		--cache-registry-username "00000000-0000-0000-0000-000000000000" \
		--cache-registry-password "$$(az acr login --expose-token -n radixdevapp.azurecr.io --query accessToken -o tsv)" \
		--push
