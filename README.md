# Vehicle App

This is a simple vehicle app that allows Vehicle inspectors to check whether a vehicle needs to be seized or not.

## Building the App

To run the app in Docker compose,

```bash
docker compose up -d
```

Access the production frontend at [http://localhost:3001](http://localhost:3001).

To run the app in kubernetes,

```bash
kubectl apply -f k8s-deployment.yaml
```

Expose the service using a LoadBalancer or NodePort as per your Kubernetes setup.