This README is designed for your GitHub repository. It’s written so that a new learner can follow your exact journey—from setting up the cluster to fixing the database and networking issues you solved today.

---

# Two-Tier Flask App Deployment on AWS EKS

This project demonstrates a complete DevOps lifecycle: containerizing a 2-tier Python Flask application, deploying it to a managed Kubernetes cluster (Amazon EKS), and solving real-world networking and database connectivity challenges.

## 🚀 Project Overview

* **Frontend:** Python Flask (listening on port 5000)
* **Backend:** MySQL 8.0
* **Orchestration:** Kubernetes (AWS EKS)
* **Infrastructure:** AWS Load Balancer (ELB)

---

## 🛠 Prerequisites

* AWS CLI configured with IAM permissions.
* `eksctl` and `kubectl` installed.
* A GitHub Personal Access Token (PAT).

---

## 📑 Step-by-Step Execution

### 1. Cluster Infrastructure

Create the EKS cluster using `eksctl`. This sets up the control plane and worker nodes.

```bash
eksctl create cluster --name my-two-tier-cluster --region eu-west-1 --fargate

```

### 2. Prepare the Kubernetes Manifests

Navigate to your project directory and create the namespace and secrets for the database.

```bash
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/mysql-secrets.yml

```

### 3. Deploy MySQL (The Database Tier)

Apply the MySQL deployment and service.

> **Note:** Ensure your `mysql.yml` includes the `MYSQL_DATABASE` environment variable to avoid "Unknown database" errors.

```bash
kubectl apply -f k8s/mysql.yml

```

### 4. Deploy the Flask App (The Application Tier)

Deploy the 5 replicas of your Python application.

```bash
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml

```

### 5. Essential Troubleshooting Commands

If the app doesn't connect or the site doesn't load, use these commands used during development:

* **Check Pod Status:** `kubectl get pods -n nginx`
* **Check Logs:** `kubectl logs <pod-name> -n nginx`
* **Restart App Pods:** `kubectl rollout restart deployment two-tier-app-deployment -n nginx`
* **Test Internal Connectivity:** `curl -v <POD_IP>:5000`

---

## 🌐 Networking & Security (Crucial)

To access the app via the **External IP** provided by `kubectl get svc -n nginx`, you must update your **AWS EC2 Security Groups**:

1. **NodePort Access:** Open Port Range `30000-32767` to `0.0.0.0/0`.
2. **App Access:** Open Port `80` (HTTP) to `0.0.0.0/0`.
3. **Internal Traffic:** Allow **All TCP** traffic with the Security Group itself as the source.

---

## 🧹 Cleanup

To avoid unexpected AWS charges, delete all resources once finished:

```bash
eksctl delete cluster --name my-two-tier-cluster --region eu-west-1

```

---

## 👤 Author

**Karan Sharma** *Final Year B.Tech CS Student | DevOps Enthusiast*

---
