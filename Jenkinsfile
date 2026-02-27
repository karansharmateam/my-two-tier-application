@Library("Shared") _

pipeline {
    agent { label "dev" }

    environment {
        DOCKER_IMAGE = "karansharmadocker123/two-tier-flask-app" 
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        EKS_CLUSTER_NAME = "my-eks-cluster"
    }

    stages {
        stage("Code Clone") {
            steps {
                script {
                    clone("https://github.com/karansharmateam/my-two-tier-application.git", "master")
                }
            }
        }

        stage("Trivy Security Scan") {
            steps {
                script {
                    trivy_fs() 
                }
            }
        }

        stage("Build & Tag Image") {
            steps {
                echo "Building Docker Image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    docker_push("dockerHubCreds", "${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage("Deploy to Amazon EKS") {
            steps {
                script {
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}"
                    
                    sh "kubectl apply -f k8s/deployment.yml"
                    sh "kubectl apply -f k8s/service.yml"
                    sh "kubectl apply -f k8s/mysql.yml"
                    sh "kubectl rollout status deployment/two-tier-app-deployment"
                    
                }
            }
        }
    }

    post {
        success {
            script {
                emailext(
                    to: 'karansharma54332@gmail.com',
                    subject: "SUCCESS: Build #${env.BUILD_NUMBER} - ${env.JOB_NAME}",
                    body: "Deployment of ${DOCKER_IMAGE} to EKS was successful!"
                )
            }
        }
        failure {
            script {
                emailext(
                    to: 'karansharma54332@gmail.com',
                    subject: "FAILURE: Build #${env.BUILD_NUMBER} - ${env.JOB_NAME}",
                    body: "The pipeline failed Please check the logs at ${env.BUILD_URL}"
                )
            }
        }
    }
}
