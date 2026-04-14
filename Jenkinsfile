pipeline {
    agent any

    // These are variables used throughout the pipeline
    environment {
        DOCKERHUB_USERNAME = 'virendranawkar'
        FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/doctor-frontend"
        BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/doctor-backend"
        COMPOSE_FILE = '/home/vir/Doctor-Appiontment/docker-compose.yml'
    }

    stages {

        // Stage 1 - Print info, confirm everything is ready
        stage('Checkout') {
            steps {
                echo '📥 Code checked out from GitHub'
                sh 'docker --version'
                sh 'docker compose version'
            }
        }

        // Stage 2 - Build both Docker images
        stage('Build Images') {
            steps {
                echo '🔨 Building Docker images...'

                // Build backend image
                // -t = tag, gives the image a name
                sh "docker build -t ${BACKEND_IMAGE}:latest ./api"

                // Build frontend image
                sh "docker build -t ${FRONTEND_IMAGE}:latest ."
            }
        }

        // Stage 3 - Login to DockerHub and push images
        stage('Push to DockerHub') {
            steps {
                echo '📤 Pushing images to DockerHub...'

                // 'dockerhub-creds' is the ID we saved in Jenkins credentials
                // withCredentials injects username/password securely
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {

                    // Login to DockerHub using credentials from Jenkins
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"

                    // Push backend image
                    sh "docker push ${BACKEND_IMAGE}:latest"

                    // Push frontend image
                    sh "docker push ${FRONTEND_IMAGE}:latest"
                }
            }
        }

        // Stage 4 - Stop old containers and start new ones
        stage('Deploy') {
            steps {
                echo '🚀 Deploying with Docker Compose...'

                // Stop and remove old containers
                sh "docker compose -f ${COMPOSE_FILE} down"

                // Start fresh containers with new images
                sh "docker compose -f ${COMPOSE_FILE} up -d"

                echo '✅ Deployment complete!'
            }
        }
    }

    // This runs after pipeline finishes - success or failure
    post {
        success {
            echo '🎉 Pipeline succeeded! App is live.'
        }
        failure {
            echo '❌ Pipeline failed! Check logs above.'
        }
    }
}
