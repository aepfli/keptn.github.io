
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
VOLUMES := -v $(ROOT_DIR):/src 
# renovate: datasource=docker depName=klakegg/hugo
HUGO_VERSION := 0.107.0
IMAGE := klakegg/hugo:$(HUGO_VERSION)-ext
PORT := 1314
DOCKER_CMD := docker run --rm -t -e HUGO_CACHEDIR=/src/tmp/.hugo -e HUGOxPARAMSxGITHUB_REPO=""

.PHONY: build server clean shell

build:
	$(DOCKER_CMD) $(VOLUMES) $(IMAGE) -D -v

shell:
	$(DOCKER_CMD) -i $(VOLUMES) $(IMAGE) shell

server:
	$(DOCKER_CMD) $(VOLUMES) -p  $(PORT):$(PORT) $(IMAGE) server -D -p $(PORT)

clean:
	$(DOCKER_CMD) $(VOLUMES) $(IMAGE) --cleanDestinationDir


.PHONY: htmltest

# renovate: datasource=docker depName=wjdp/htmltest
HTMLTEST_VERSION := v0.17.0
htmltest: build
	$(DOCKER_CMD) -v $(ROOT_DIR):/test wjdp/htmltest:$(HTMLTEST_VERSION) -c .htmltest.yml public
