pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        IMAGE_TAG = 'latest'
        CLUSTER_NAME = 'vehicle'
    }

    stages {
        stage('Set Environment') {
            parallel {
                stage('Set Image Tag') {
                    steps {
                        script {
                            withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                                env.BACKEND_IMAGE = sh(
                                    script: "aws ecr describe-repositories --repository-names vehicle-backend-bloom --query \"repositories[0].repositoryUri\" --output text",
                                    returnStdout: true
                                ).trim()
                                env.FRONTEND_IMAGE = sh(
                                    script: "aws ecr describe-repositories --repository-names vehicle-frontend --query \"repositories[0].repositoryUri\" --output text",
                                    returnStdout: true
                                ).trim()
                            }
                            echo "Backend Image: ${BACKEND_IMAGE}"
                            echo "Frontend Image: ${FRONTEND_IMAGE}"
                        }
                    }
                }
                stage('Set Namespace') {
                    steps {
                        script {
                            // Try Jenkins env var first, fallback to git command, then to 'development'
                            def branch = env.BRANCH_NAME
                            echo "Branch Name: ${branch}"
                            if (!branch || branch == 'HEAD') {
                                branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                            }
                            if (!branch || branch == 'HEAD') {
                                branch = 'development'
                            }
                            env.NAMESPACE = "vehicle-app-${branch.replaceAll('[^a-zA-Z0-9-]', '-').toLowerCase()}"
                        }
                    }
                }
            }
        }
        stage('Build Docker Images') {
            parallel {
                stage('Build Frontend Docker Image') {
                    steps {
                        dir('vehicle-frontend') {
                            sh '''
                                docker build -t ${FRONTEND_IMAGE}:${IMAGE_TAG} . -f ./Dockerfile.prod
                            '''
                        }
                    }
                }
                stage('Build Backend Docker Image') {
                    steps {
                        dir('vehicle-backend-bloom') {
                            sh '''
                                docker build -t ${BACKEND_IMAGE}:${IMAGE_TAG} . -f ./Dockerfile
                            '''
                        }
                    }
                }
            }
        }
        stage('Push Docker Images to ECR') {
            parallel {
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
            }
        }
        stage('Deploy DB Tier to EKS') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl config set-context --current --namespace=$NAMESPACE
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
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                        kubectl get nodes
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl config set-context --current --namespace=$NAMESPACE
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
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                        kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE
                        kubectl config set-context --current --namespace=$NAMESPACE
                        kubectl apply -f ./eks/frontend-deployment.yaml
                        kubectl apply -f ./eks/frontend-service.yaml
                    '''
                }
            }
        }
    }
}