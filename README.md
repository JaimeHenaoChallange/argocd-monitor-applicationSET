# Kubernetes ArgoCD Automation with Minikube

This project automates the deployment of microservices in a Kubernetes cluster using ArgoCD, with retry logic and Slack notifications for degraded applications.

## Prerequisites

- Docker
- Visual Studio Code with DevContainer support
- Minikube
- ArgoCD CLI
- Slack Webhook URL

## Setup Instructions

1. **Start Minikube**:
   ```bash
   minikube start --driver=docker