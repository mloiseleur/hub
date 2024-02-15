
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Used for Helm Chart
IMAGE_HELM_UNITTEST=docker.io/helmunittest/helm-unittest:3.13.3-0.4.1
IMAGE_CHART_TESTING=quay.io/helmpack/chart-testing:v3.10.1
USERID=$(shell id -u $${USER})
GROUPID=$(shell id -g $${USER})

charts/traefik-hub/tests/__snapshot__:
	@mkdir traefik-hub/tests/__snapshot__

test: charts/traefik-hub/tests/__snapshot__
	docker run ${DOCKER_ARGS} -it --rm -v $(CURDIR):/apps $(IMAGE_HELM_UNITTEST) charts/traefik-hub

lint:
	docker run ${DOCKER_ARGS} -u $(USERID):$(GROUPID) -it --rm -v $(CURDIR):/hub -w /hub $(IMAGE_CHART_TESTING) ct lint --target-branch main

