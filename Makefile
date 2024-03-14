
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`


markdown-lint:
	# https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
	# https://github.com/markdownlint/markdownlint/blob/master/lib/mdl/rules.rb
	HOME=/workdir mdl -s markdown.rb .

create-agent-token:
	@curl -s -X POST -d '{"name": "test-from-hub-repo", "gatewayEndpoint": ""}' -H "Authorization: Bearer ${TRAEFIK_HUB_API_TOKEN}" https://platform.hub.traefik.io/cluster/external/clusters > cluster.json
	@echo "export TRAEFIK_HUB_TOKEN=$(shell jq -r '.token' cluster.json)"
	@echo "export CLUSTER_ID=$(shell jq -r '.id' cluster.json)"
	@rm -f cluster.json

delete-agent-token:
	@curl -XDELETE -H "Accept: application/json" -H "Authorization: Bearer ${TRAEFIK_HUB_API_TOKEN}" "https://platform.hub.traefik.io/cluster/external/clusters/${CLUSTER_ID}"
	@rm -f cluster.json
