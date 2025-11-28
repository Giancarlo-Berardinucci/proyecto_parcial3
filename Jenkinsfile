pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t taskapp:jenkins .
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo "Starting test container..."

                    # Elimina contenedor si existe
                    docker stop taskapp_test || true
                    docker rm taskapp_test || true

                    # Levanta contenedor de pruebas
                    docker run -d --name taskapp_test -p 5000:5000 taskapp:jenkins
                '''
            }
        }

        stage('Scan') {
            steps {
                sh '''
                    echo "Running OWASP ZAP Baseline Scan..."

                    docker run --rm --name zap_baseline \
                        zaproxy/zap-stable \
                        zap-baseline.py -t http://host.docker.internal:5000 || true
                '''
            }
        }

        stage('Stop Test Container') {
            steps {
                sh '''
                    docker stop taskapp_test || true
                    docker rm taskapp_test || true
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    echo "Deploying production container..."

                    # Elimina contenedor previo
                    docker stop taskapp_prod || true
                    docker rm taskapp_prod || true

                    # Levanta contenedor productivo
                    docker run -d --name taskapp_prod -p 5001:5000 taskapp:jenkins
                '''
            }
        }

    }
}
