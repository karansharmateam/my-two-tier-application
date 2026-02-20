@Library("Shared") _
pipeline {
    agent { label "dev" }

    stages {
        stage("Code Clone") {
            steps {
                script {
                    clone("https://github.com/karansharmateam/my-two-tier-application.git", "master")
                }
            }
        }

        stage("Trivy file system scan") {
            steps {
                script {
                    trivy_fs()
                }
            }
        }

        stage("Build & Test") {
            steps {
                echo "Building and tagging the image..."
                sh "docker build -t two-tier-flask-app ."
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    docker_push("dockerHubCreds", "two-tier-flask-app")
                }
            }
        }

        stage("Deploy") {
            steps {
                sh "docker compose up -d"
            }
        }
    }

    post {
        success {
            script {
                emailext(
                    from: 'karansharma@gmail.com',
                    to: 'karansharma@gmail.com',
                    body: 'Build success for Demo CICD app',
                    subject: 'Build success for Demo CICD App'
                )
            }
        }
        failure {
            script {
                emailext(
                    from: 'karansharma@gmail.com',
                    to: 'karansharma@gmail.com',
                    body: 'Build Failed for Demo CICD App',
                    subject: 'Build Failed for Demo CICD App'
                )
            }
        }
    }
}


    
























      
