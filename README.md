# Traefik Hub

<div align="center" style="margin: 30px;">
<a href="https://hub.traefik.io/">
  <img src="https://doc.traefik.io/traefik-hub/assets/images/logos-traefik-hub-horizontal.svg" style="width:250px;" align="center" />
</a>
<br />
<br />

<div align="center">
    <a href="https://hub.traefik.io">Log In</a> |
    <a href="https://doc.traefik.io/traefik-hub/">Documentation</a>
</div>
</div>

<br />

<div align="center"><strong>Traefik Hub</strong>

<br />
<br />
</div>

<div align="center">Welcome to this repository!</div>

## ℹ️ About

This repository host Traefik Hub public source code:

1. Helm Chart
2. Tutorials
3. Demo

GH actions ensure the code source on this repository works with current stable version of Traefik Hub.

## ⬇️ Install

### Prerequisites

1. [kubectl](https://kubernetes.io/docs/tasks/tools/) command-line tool installed and configured to access the cluster
2. [gh](https://cli.github.com/) command-line tool installed and configured with your account
3. [Flux CD](https://fluxcd.io/flux/cmd/) command-line tool installed.
4. A Kubernetes cluster running.

All tutorials in this demo are tested using [kind](https://kind.sigs.k8s.io).

To test Traefik Hub with a local Kubernetes, see [this tutorial](./tutorials/0-prerequisites/README.md).

## 📒 Repository Structure

```shell
.
├── api-server                        # API server source code
├── apps                              # Yaml to deploy all apps
├── charts
│   └── traefik-hub                   # Chart source code
├── demo
│   ├── gitops                        # GitOps demo, with FluxCD specifics
│   └── observability                 # Observability demo, used in GitOps demo
├── LICENSE
├── Makefile
├── README.md
└── tutorials
    ├── 0-prerequisites
    ├── 1-getting-started
    ├── 2-advanced-use-cases
    ├── 3-access-control
    ├── 4-version-management
    ├── 5-users-documentation
    ├── 6-protect-infrastructure
    └── 7-management-at-scale
```

## 📃 License

The content in this repository is licensed under the [Apache 2 License](https://www.apache.org/licenses/LICENSE-2.0 "Link to Apache 2 license").
