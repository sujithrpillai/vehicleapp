pipeline {
    agent any

    environment {
        IMAGE_NAME = 'srpillai/vehicleapp-frontend:latest'
        AWS_REGION = 'us-east-1' 
        ECR_REPO = '874954573048.dkr.ecr.us-east-1.amazonaws.com/vehicle-frontend'
        IMAGE_TAG = 'latest'
        NAMESPACE = "vehicle-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/sujithrpillai/vehicleapp.git'
                sh '''
                    ls -l vehicle-frontend
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('vehicle-frontend') {
                    sh '''
                        ls -l
                        docker build -t ${ECR_REPO}:${IMAGE_TAG} ./vehicle-frontend -f ./vehicle-frontend/Dockerfile.prod
                    '''
                }
            }
        }

        stage('Push image to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                        docker push ${ECR_REPO}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name sr
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                    '''
                }
            }
        }

    }
}