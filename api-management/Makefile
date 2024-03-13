

all: tutorials

tutorials: getting-started advanced-use-cases

.kube-cluster:
	kind create cluster --config=tutorials/0-prerequisites/kind/config.yaml
	kubectl cluster-info
	kubectl wait --for=condition=ready nodes traefik-hub-control-plane
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.11/config/manifests/metallb-native.yaml
	kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
	kubectl apply -f tutorials/0-prerequisites/kind/metallb-config.yaml
	@echo "traefik-hub" > .kube-cluster

.traefik-hub: .kube-cluster
ifndef TRAEFIK_HUB_TOKEN
	$(error TRAEFIK_HUB_TOKEN is undefined)
endif
	kubectl create namespace traefik-hub
	@kubectl create secret generic hub-agent-token --namespace traefik-hub --from-literal=token=$(TRAEFIK_HUB_TOKEN)
	helm repo add --force-update traefik https://traefik.github.io/charts
	helm install traefik-hub $(TRAEFIK_HUB_ARGS) -n traefik-hub -f tutorials/0-prerequisites/kind/values.yaml --wait traefik/traefik-hub
	@touch .traefik-hub

getting-started: .traefik-hub
	kubectl apply -f src/manifests/public-app.yaml
	kubectl apply -f tutorials/1-getting-started/manifests/public-api.yaml
	kubectl apply -f tutorials/1-getting-started/manifests/api-access.yaml
	kubectl apply -f tutorials/1-getting-started/manifests/api-gateway.yaml

.PHONY: clean


test-%: .traefik-hub
	bash $(subst test-,test/,$@).sh

clean-hub:
	helm uninstall traefik-hub -n traefik-hub
	kubectl delete namespace traefik-hub
	rm -f .traefik-hub

clean:
	kind delete cluster --name traefik-hub
	rm -f .kube-cluster .traefik-hub
