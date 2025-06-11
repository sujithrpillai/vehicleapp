pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' 
        FRONTEND_IMAGE = '874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-frontend'
        BACKEND_IMAGE = '874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-backend-bloom'
        IMAGE_TAG = 'latest'
        NAMESPACE = "vehicle-app"
    }

    stages {
        stage('Build Frontend Docker Image') {
            steps {
                dir('vehicle-frontend') {
                    sh '''
                        ls -l
                        docker build -t ${FRONTEND_IMAGE}:${IMAGE_TAG} . -f ./Dockerfile.prod
                    '''
                }
            }
        }

        stage('Push Frontend image to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${FRONTEND_IMAGE}
                        docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }
        stage('Build Backend Docker Image') {
            steps {
                dir('vehicle-backend-bloom') {
                    sh '''
                        ls -l
                        docker build -t ${BACKEND_IMAGE}:${IMAGE_TAG} . -f ./Dockerfile
                    '''
                }
            }
        }

        stage('Push Backend image to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${BACKEND_IMAGE}
                        docker push ${BACKEND_IMAGE}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }
        stage('Deploy DB Tier to EKS') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name sr
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl apply -f ./eks/db*
                        kubectl apply -f ./eks/mongo-seed-configMap.yaml
                        kubectl apply -f ./eks/mongo-seed-job.yaml
                    '''
                }
            }
        }
        stage('Deploy Backend to EKS') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name sr
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl apply -f ./eks/backend-deployment.yaml
                        kubectl apply -f ./eks/backend-service.yaml
                    '''
                }
            }
        }
        stage('Deploy Frontend to EKS') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name sr
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl apply -f ./eks/backend-deployment.yaml
                        kubectl apply -f ./eks/backend-service.yaml
                    '''
                }
            }
        }

    }
}