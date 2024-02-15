# About

This tutorial details how to deploy locally a Kubernetes cluster.

# Prerequisites

If you'd like to follow along with this tutorial on your own machine, you'll need a few things first:

1. [kubectl](https://github.com/kubernetes/kubectl) command-line tool installed

In this tutorial, you'll use [kind](https://kind.sigs.k8s.io). You may also use alternatives like [k3d](https://k3d.io/), cloud providers, or others.

kind requires some configuration to use an IngressController on localhost, see the following example:

```shell
cat kind.config
```

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: traefik-hub
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 80
    protocol: TCP
  - containerPort: 30001
    hostPort: 443
    protocol: TCP
```

1. Clone this GitHub repository:

```shell
git clone https://github.com/traefik/hub.git
cd traefik-hub
```

2. Create the Kubernetes cluster:

**Using kind**

Create the cluster:

```shell
kind create cluster --config=tutorials/0-prerequisites/kind/config.yaml
kubectl cluster-info
kubectl wait --for=condition=ready nodes traefik-hub-control-plane
```

Add a load balancer (LB) to this Kubernetes cluster:

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.11/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
kubectl apply -f tutorials/0-prerequisites/kind/metallb-config.yaml
```

**Using k3d**

```shell
k3d cluster create traefik-hub --port 80:80@loadbalancer --port 443:443@loadbalancer --port 8000:8000@loadbalancer --k3s-arg "--disable=traefik@server:0"
```

# Clean up

Everything is installed in Kubernetes.
You can delete the Kubernetes cluster with the following command:

```shell
# kind
kind delete cluster --name traefik-hub
```

```shell
# k3d
k3d delete cluster traefik-hub
```
