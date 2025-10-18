# deploy a helm chart to a kubernetes cluster
pipeline {
    agent any
    environment {
        APP_NAME = "my-java-app"
        IMAGE_NAME = "my-java-app"
        IMAGE_TAG = "latest"
        KUBE_CONTEXT = "minikube"
        
    }

    stages {
        stage('Checkout') {
    steps {
        git branch: 'main',
            url: 'https://github.com/avkhaladkar1991/cicd-jenkins-docker-helm-kubernetes.git',
            credentialsId: 'github-creds'
    }
}
        stage('Build') {
            steps {
                echo " Building Java application..."
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Build Docker Image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                
            }
        }

        stage('Load into Minikube') {
            steps {
                echo "📦 Loading image into Minikube..."
                sh "minikube image load ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

         stage('Helm Deploy') {
            steps {
                echo "🚀 Deploying application to Kubernetes using Helm..."
                sh """
                    helm upgrade --install ${APP_NAME} ./helm-chart \
                      --set image.repository=${IMAGE_NAME} \
                      --set image.tag=${IMAGE_TAG} \
                      --set image.pullPolicy=IfNotPresent
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Checking Kubernetes resources..."
                sh 'kubectl get pods'
                sh 'kubectl get svc'
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
            sh "minikube service ${APP_NAME} --url || true"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}  
        
              
    
