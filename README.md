# 🌻 Sunflower Lab – DevOps Assignment

## 📌 Overview

This repository contains a production-style DevOps setup built to satisfy the requirements of the take-home assessment.

### 🎯 Goals of the Assignment

The goal of this assignment is to:

- Provision a Kubernetes cluster (adapted to **k3d** for local multi-node simulation)
- Implement GitOps using **ArgoCD**
- Deploy a sample API
- Set up a complete **LGTM observability stack**:
  - **Grafana** (dashboards)
  - **Loki** (logs)
  - **Tempo** (traces)
  - **Prometheus** (metrics)

### ✅ Key Characteristics

The system is designed to be:

- Fully reproducible  
- Automated  
- Production-aligned  

## 🧠 Key Design Decisions

### ❓ Why k3d instead of k3s?

Although the original requirement mentions **k3s**, a multi-node cluster was expected.

Due to local resource constraints, we used:

- **k3d** (k3s inside Docker) to simulate a multi-node cluster efficiently

### 🚀 Benefits of This Approach

This allows:

- Multi-node setup (**1 server + 2 agents**)  
- Lightweight resource usage  
- Same Kubernetes behavior as **k3s**  

---

### ❓ Why NGINX Ingress (instead of Traefik)?

**k3s** includes **Traefik** by default.

However, we chose **NGINX Ingress Controller** because it is more widely used in production environments.

### 🚀 Advantages of NGINX Ingress

It offers better compatibility with:

- **ArgoCD**  
- Observability stack  
- Helm charts  

---

### ❓ Why NAT Networking (instead of Bridge)?

The host system uses WiFi, which makes bridge networking unreliable.

Instead, we use **NAT (virbr0)**, which provides:

- Stable connectivity  
- Predictable behavior  

### 🌐 Service Exposure

Services are exposed via:

- **k3d load balancer port mappings**

---

## 🖥️ VM Setup

### 🧾 Operating System

- **Ubuntu 24.04 LTS (Server Edition)**

### ⚙️ Minimum Specifications

- **CPU:** 2 vCPU (4 recommended)  
- **RAM:** 4 GB (8 GB recommended for observability stack)  
- **Disk:** 40 GB  

---
## 🌐 Networking Configuration

- Static IP configured using **Netplan**  
- Cloud-init network override disabled to ensure persistence  

### 📍 Example IP

    192.168.122.50


### ❓ Why Static IP?

- Predictable access  
- Required for consistent ingress routing  
- Avoids DHCP changes  

---

## ⚙️ VM Setup Steps

```bash
cd bootstrap/vm-setup
./00-setup-network.sh
```
Then reboot the VM.

---

## ⚙️ Cluster Setup

All cluster-related setup is modular and located under: **bootstrap/cluster-setup/**

    cd bootstrap/cluster-setup/
### Step 1: Install Docker

    ./01-install-docker.sh

-   Installs Docker CE

-   Enables service

-   Adds user to docker group

Reboot required after this step

### Step 2: Install kubectl

    ./02-install-kubectl.sh

-   Uses official Kubernetes repository

-   Installs latest stable kubectl

### Step 3: Install Helm

    ./03-install-helm.sh

-   Uses official Helm install script

-   Helm v3 is used for compatibility

### Step 4: Install k3d

    ./04-install-k3d.sh

-   Installs k3d (k3s in Docker)

-   Enables multi-node cluster creation

### Step 5: Create Multi-Node Cluster

    ./05-create-k3d-cluster.sh

Cluster configuration:

-   1 control-plane node

-   2 worker nodes

#### Key Configurations

-   Traefik disabled

-   NGINX Ingress used instead

-   Port mappings:

-   8080 → HTTP

-   8443 → HTTPS

#### Control Plane Isolation

The control-plane node is tainted:

    NoSchedule

This ensures:

-   Workloads run only on worker nodes

-   Aligns with production practices

### Step 6: Install ArgoCD (Bootstrap)

    ./06-install-argocd.sh

-   Installed using official manifest

-   Uses server-side apply to avoid CRD size issues

-   Accessed via port-forward initially

#### Why not Helm?

ArgoCD is the GitOps controller itself, so:

-   It must be installed during bootstrap

-   Not managed by itself (avoids circular dependency)

* * * * *

🔐 ArgoCD Access
----------------

    kubectl port-forward svc/argocd-server -n argocd 8081:443 --address 0.0.0.0

-   This let's you access Argocd from your Host machine using VM static IP and port