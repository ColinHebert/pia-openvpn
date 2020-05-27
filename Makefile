# https://github.com/jmkhael/make-for-docker
include make_env

NS ?= act28
VERSION ?= latest

IMAGE_NAME ?= pia-openvpn
CONTAINER_NAME ?= pia-openvpn
CONTAINER_INSTANCE ?= default

OPTS ?= \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--dns=209.222.18.218 --dns=209.222.18.222 \
--restart=always

ARGS ?=

.PHONY: build push shell run start stop rm release

build: Dockerfile
	docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

push:
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)

shell:
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(OPTS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

run:
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(OPTS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) $(ARGS)

start:
	docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(OPTS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) $(ARGS)

stop:
	docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
	docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

test:
	docker run --rm --network=container:$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) appropriate/curl -s ipecho.net/plain

default: build
