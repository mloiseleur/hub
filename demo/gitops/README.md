# GitOps Demo

## Configure Traefik Hub

Login to the [Traefik Hub UI](https://hub.traefik.io), open the page to [generate a new agent](https://hub.traefik.io/agents/new).
**Do not install the agent, but copy your token.**

Now, open a terminal and run these commands to create the secret needed for Traefik Hub.

```shell
export TRAEFIK_HUB_TOKEN=xxx
kubectl create namespace traefik-hub
kubectl create secret generic hub-agent-token --namespace traefik-hub --from-literal=token=${TRAEFIK_HUB_TOKEN}
```

## Deploy the stack on the cluster

Then, you can configure flux and launch it on the fork.
You'll need to create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)(PAT) with repo access on your fork.

First, export your GitHub username and your newly created PAT into a variable.

```shell
export GITHUB_ACCOUNT=xxx
export GITHUB_TOKEN=yyy
```

Second, configure Flux CD for your fork of this tutorial.

```shell
flux create secret git git-auth  --url="https://github.com/${GITHUB_ACCOUNT}/traefik-hub-gitops" --namespace=flux-system -u git -p "${GITHUB_TOKEN}"
```

Third, adjust the repository on Flux to use your fork.

```shell
sed -i -e "s/traefik-workshops/${GITHUB_ACCOUNT}/g" clusters/kind/flux-system/gotk-sync.yaml
git commit -m "feat: GitOps on my fork" clusters/kind/flux-system/gotk-sync.yaml
git push origin
```

In the next step, deploy the repository.

```shell
kubectl apply -f clusters/kind/flux-system/gotk-sync.yaml
```

This will start the [Kustomization](https://fluxcd.io/flux/components/kustomize/kustomizations/).
Flux will now sync, validate and deploy all components.

This process will take several minutes.

You can track the process from the CLI.

```shell
flux get ks
```

![Kustomizations are ready](./images/kustomizations-ready.png)

## Configure traffic generation

To generate traffic, create two users, an `admin` and a `support` user and their groups.

The `admin` user needs to be part of the `admin` group and the `support` user needs to be part of the `support` group.

<details>
  <summary>Traefik Hub UI</summary>

Create the `admin` user in the Traefik Hub UI:

![Create user admin](./images/create-user-admin.png)

Create the `support` user:

![Create user support](./images/create-user-support.png)

</details>

When the Kustomization is **ready**, you can open API Portal, following URL available in the UI or in the CRD:

```shell
kubectl get apiportal
```

Log in to the API Portal:

![API Portal Login](./images/api-portal-login.png)

Now, create API tokens for both users.

![Create API Token](./images/create-api-token.png)

Create a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) containing the tokens to enable the traffic app to generate load:

```shell
export ADMIN_TOKEN="xxx"
export SUPPORT_TOKEN="yyy"
kubectl create secret generic tokens -n traffic --from-literal=admin="${ADMIN_TOKEN}" --from-literal=support="${SUPPORT_TOKEN}"
```

## Use observability stack

Grafana is accessible on http://grafana.docker.localhost

Prometheus is on http://prometheus.docker.localhost

Default credentials are login: admin and password: admin.

By clicking on the left menu, you can access all dashboards:

![Grafana Dashboards](./images/grafana-dashboards.png)

## Enable event correlation

**Flux events**: Add a new Grafana service account with a new key at http://grafana.docker.localhost/org/serviceaccounts
and add the token (starting with `glsa_`) to the `apps/base/monitoring/flux-grafana.yaml` file.

```shell
export GRAFANA_TOKEN="xxx"
sed -i -e "s/token:\(.*\)/token: \""${GRAFANA_TOKEN}"\"/g" apps/base/monitoring/flux-grafana.yaml
```

Now, Flux can create annotations of reconciliation events in the dashboards.

**GitHub PR merges**: Add a new Grafana connection (GitHub data source) at http://grafana.docker.localhost/connections/datasources/grafana-github-datasource
You must add a Personal Access Token (PAT) to GitHub at https://github.com/settings/tokens/new, as explained in the Grafana connection creation wizard.
When configured, edit the dashboards to add new annotations using the GitHub data source:

- Show in: All panels
- Query type: Pull Requests
- Owner / Repository: your user and the repo name of the fork
- Query: leave it empty
- Time Field: MergedAt
- Annotations:
   - Time field: `merged_at (time)`
   - Title: `title (string)`
   - Text: `url (string)`
   - End time + tags + id: leave them empty
