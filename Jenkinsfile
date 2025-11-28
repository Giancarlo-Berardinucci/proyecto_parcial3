pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t taskapp:jenkins .'
            }
        }

        stage('Run Container for Tests') {
            steps {
                sh 'docker run -d --rm --name taskapp_test -p 5000:5000 taskapp:jenkins'
            }
        }

        stage('Security Scan (ZAP Baseline)') {
            steps {
                sh '''
                    docker run --rm --name zap_baseline \
                      -t owasp/zap2docker-stable zap-baseline.py \
                      -t http://host.docker.internal:5000
                '''
            }
        }

        stage('Stop Test Container') {
            steps {
                sh 'docker stop taskapp_test || true'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop taskapp_prod || true
                    docker rm taskapp_prod || true
                    docker run -d --name taskapp_prod -p 5001:5000 taskapp:jenkins
                '''
            }
        }
    }
}
