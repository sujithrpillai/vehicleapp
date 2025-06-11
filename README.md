# Vehicle App

This is a simple vehicle app that allows Vehicle inspectors to check whether a vehicle needs to be seized or not.

## Building the App

To run the app in Docker compose,

```bash
docker compose up -d
```
Access the development frontend at [http://localhost:3000](http://localhost:3000).
Access the production frontend at [http://localhost:3001](http://localhost:3001).

To run the app in kubernetes,

```bash
kubectl apply -f k8s-deployment.yaml
```

Expose the service using a LoadBalancer or NodePort as per your Kubernetes setup.

## Using the already built application image

The application image is available in the Docker Hub (arm64 version).

Pull the image using:

```bash
docker pull srpillai/vehicleapp-frontend:latest      # Frontend
docker pull srpillai/vehicleapp-backend-bloom:latest # Backend
```

## Image Build steps for reference

```bash
cd vehicle-backend-bloom
docker build -t srpillai/vehicleapp-backend-bloom:latest . -f Dockerfile --no-cache
cd ../vehicle-frontend
docker build -t srpillai/vehicleapp-frontend:latest . -f Dockerfile.prod --no-cache
docker push srpillai/vehicleapp-backend-bloom:latest
docker push srpillai/vehicleapp-frontend:latest
```


# AWS Steps

```bash
# Create the EKS cluster
eksctl create cluster -f cluster.yaml
# OR
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
aws eks update-kubeconfig --name <cluster name>>
```

```bash

# Create the ECR repositories
aws ecr create-repository --repository-name vehicle-backend-bloom
aws ecr create-repository --repository-name vehicle-frontend

# Build the backend image and push to ECR
cd vehicle-backend-bloom
docker build --platform linux/amd64 -t vehicle-backend-bloom .
docker tag vehicle-backend-bloom:latest 874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-backend-bloom:latest
docker push 874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-backend-bloom:latest

# Build the frontend image and push to ECR
cd ../vehicle-frontend
docker build --platform linux/amd64 -t vehicle-frontend . -f Dockerfile.prod
docker tag vehicle-frontend:latest 874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-frontend:latest
docker push 874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-frontend:latest
```

```bash
# Deploy the application
kubectl create namespace vehicle-app
kubectl config set-context --current --namespace=vehicle-app
kubectl kubectl apply -f backend-deployment.yaml
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```


# Install Prometheus for Monitoring
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/prometheus --namespace monitoring
helm install prometheus-adapter prometheus-community/prometheus-adapter --namespace monitoring
```
# Modify the prometheus-server service to use LoadBalancer
```
kubectl patch svc prometheus-server -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'
```

cd HPA
helm upgrade --install prometheus-adapter prometheus-community/prometheus-adapter \
  --namespace monitoring -f values.yaml

kubectl apply -f hpa.yaml