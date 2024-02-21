# 3 OIDC configurations with Traefik Hub on Kubernetes

Distributed systems require a strategic approach to [authentication and authorization](https://traefik.io/glossary/openid-connect-everything-you-need-to-know/?ref=github). As the number of components grows, controlling access to services becomes more and more complex. To alleviate this complexity, many organizations adopt the [API gateway model](https://traefik.io/blog/centralizing-and-standardizing-oidc-at-the-api-gateway-level/?ref=github), where security is standardized at a single point of ingress into a network.

In this blog post, we’ll walk through three configurations in which Traefik Enterprise is used to enforce access control via [OpenID Connect (OIDC)](https://traefik.io/glossary/openid-connect-everything-you-need-to-know/?ref=github) — a solid choice for any authentication strategy.

# Setting up the environment

## Installing Traefik Hub in Kubernetes

Login to the [Traefik Hub UI](https://hub.traefik.io), open the page to [generate a new agent](https://hub.traefik.io/agents/new).
**Do not install the agent, but copy your token.**

Now, open a terminal and run these commands to create the secret needed for Traefik Hub.

```shell
export TRAEFIK_HUB_TOKEN=xxx
kubectl create namespace traefik-hub
kubectl create secret generic hub-agent-token --namespace traefik-hub --from-literal=token=${TRAEFIK_HUB_TOKEN}
```

We'll configure Traefik Hub with those helm values:

```yaml
service:
  type: LoadBalancer
  # Needed on local Kind k8s cluster.
  # Can be removed or customized as needed on other k8s cluster.
  ports:
    - port: 80
      name: web
      targetPort: web
      nodePort: 30000
    - port: 443
      name: websecure
      targetPort: websecure
      nodePort: 30001
```

To install it:

```shell
helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik-hub -f values.yaml -n traefik-hub traefik/traefik-hub
```
