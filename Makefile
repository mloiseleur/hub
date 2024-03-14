
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
	@echo **************
	@echo "export TRAEFIK_HUB_TOKEN=$$(jq -r '.token' cluster.json)"
	@echo "export CLUSTER_ID=$$(jq -r '.id' cluster.json)"
	@echo **************

delete-agent-token:
	@echo "cluster_id: ${CLUSTER_ID}"
	@curl -s -XDELETE -H "Accept: application/json" -H "Authorization: Bearer ${TRAEFIK_HUB_API_TOKEN}" "https://platform.hub.traefik.io/cluster/external/clusters/${CLUSTER_ID}"
	@rm -f cluster.json
