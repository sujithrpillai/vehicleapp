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
