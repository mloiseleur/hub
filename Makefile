
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Used for Helm Chart
IMAGE_HELM_UNITTEST=docker.io/helmunittest/helm-unittest:3.13.3-0.4.0
IMAGE_CHART_TESTING=quay.io/helmpack/chart-testing:v3.10.1

charts/traefik-hub/tests/__snapshot__:
	@mkdir traefik-hub/tests/__snapshot__

test: charts/traefik-hub/tests/__snapshot__
	docker run ${DOCKER_ARGS} --entrypoint /bin/sh --rm -v $(CURDIR)/charts:/charts -w /charts $(IMAGE_HELM_UNITTEST) /charts/hack/test.sh

lint:
	docker run ${DOCKER_ARGS} --env GIT_SAFE_DIR="true" -it --rm -v $(CURDIR):/hub -w /hub $(IMAGE_CHART_TESTING) ct lint

