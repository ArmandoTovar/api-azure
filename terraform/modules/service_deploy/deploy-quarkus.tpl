name: Deploy Quarkus to AKS

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Build Quarkus Container
        run: |
          mvn package -DskipTests
          docker build -f src/main/docker/Dockerfile.jvm -t $${{ vars.CONTAINER_REGISTRY }}.azurecr.io/todo-quarkus-aks:1.0 .
        env:
          SERVICE_ACCOUNT_NAME: $${{ vars.SERVICE_ACCOUNT_NAME }}
          REGISTER_NAME: $${{ vars.CONTAINER_REGISTRY }}
      - name: Log in to Azure
        uses: azure/login@v2
        with:
          creds: $${{ secrets.AZURE_CREDENTIALS }}
          enable-AzPSSession: true
      - name: Push Image to Container Registry
        run: |
          az acr login --name $${{ vars.CONTAINER_REGISTRY }}
          docker push $${{ vars.CONTAINER_REGISTRY }}.azurecr.io/todo-quarkus-aks:1.0
      - name: Get AKS Credentials
        run: |
          az aks get-credentials --resource-group $${{ vars.RESOURCE_GROUP }} --name $${{ vars.AKS_NAME }} --overwrite-existing
      - name: Deploy to AKS
        run: |
          kubectl apply -f  kubernetes/ingress-internal.yaml
          kubectl delete services nginx -n app-routing-system
          kubectl delete deployment nginx -n app-routing-system
          kubectl apply -f target/kubernetes/kubernetes.yml
