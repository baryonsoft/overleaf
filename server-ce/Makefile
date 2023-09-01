# Makefile

export SHARELATEX_BASE_TAG := ghcr.io/baryonsoft/overleaf/sharelatex-base
export SHARELATEX_TAG := ghcr.io/baryonsoft/overleaf/sharelatex
export SHARELATEX_FULL_TAG := ghcr.io/baryonsoft/overleaf/sharelatex-full
export SHARELATEX_BASE_CACHE := $(shell echo $(SHARELATEX_BASE_TAG) | sed -E 's/(.+):.+/\1:latest/')
export MONOREPO_REVISION := $(shell git rev-parse HEAD)
MONOREPO_ROOT := ../

all: build-base build-community

build-base:
	cp .dockerignore $(MONOREPO_ROOT)
	docker pull $(SHARELATEX_BASE_CACHE) || echo "nothing cached yet"
	docker build -f Dockerfile-base --pull --cache-from $(SHARELATEX_BASE_CACHE) -t $(SHARELATEX_BASE_TAG) $(MONOREPO_ROOT)


build-community:
	cp .dockerignore $(MONOREPO_ROOT)
	docker build --build-arg SHARELATEX_BASE_TAG --build-arg MONOREPO_REVISION -f Dockerfile -t $(SHARELATEX_TAG) $(MONOREPO_ROOT)


build-community-full:
	cp .dockerignore $(MONOREPO_ROOT)
	docker build --build-arg SHARELATEX_TAG --build-arg MONOREPO_REVISION -f Dockerfile-full -t $(SHARELATEX_FULL_TAG) $(MONOREPO_ROOT)


.PHONY: all build-base build-community
