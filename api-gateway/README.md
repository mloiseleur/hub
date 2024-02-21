# Traefik Hub API Gateway

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

<div align="center">API Gateway</div>

## ⬇️ Install

### Prerequisites

1. [kubectl](https://kubernetes.io/docs/tasks/tools/) command-line tool installed and configured to access the cluster
2. [gh](https://cli.github.com/) command-line tool installed and configured with your account
3. [curl](https://curl.se/download.html) command-line tool installed.
4. A Kubernetes cluster running.

All tutorials are tested using [k3d](https://k3d.io/).

To test Traefik Hub with a local Kubernetes, see [this tutorial](./tutorials/0-prerequisites/README.md).

## 📒 Repository Structure

```shell
.
├── manifests
│   ├── whoami                        # Simple App
│   ├── hydra                         # Auth Server used as IdP for OIDC
│   └── redis                         # Redis Cache
└── tutorials
    ├── 0-prerequisites
    └── oidc
```
