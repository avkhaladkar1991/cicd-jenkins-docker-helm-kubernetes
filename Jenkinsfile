pipeline {
  agent any

  environment {
    APP_NAME    = "my-springboot-app"            // Helm release name
    IMAGE_NAME  = "my-springboot-app"            // local image name used in Dockerfile/Helm
    IMAGE_TAG   = "v1.0"                         // change as required
    CHART_DIR   = "mychart"                      // path to Helm chart in repo
    GIT_CRED_ID = "github-creds"                 // change to your Jenkins credential id (or remove)
    K8S_NAMESPACE = "default"
  }

  stages {
    stage('Checkout') {
      steps {
        script {
          // if using Pipeline job from SCM, checkout scm is ok; Otherwise specify repo and creds
          // Uncomment the git(...) block below if your pipeline is a "Pipeline script" not "Pipeline from SCM".
          // git branch: 'main', url: 'https://github.com/yourusername/cicd-jenkins-docker-helm-kubernetes.git', credentialsId: "${GIT_CRED_ID}"

          checkout scm
        }
      }
    }

    stage('Build (Maven)') {
      steps {
        echo "Building Java (mvn package)..."
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Build Docker image') {
      steps {
        echo "Building Docker image..."
        // build tag must match Helm values image.repository/image.tag or Helm will override
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Load image into Minikube') {
      steps {
        echo "Loading image into Minikube so K8s can pull it locally..."
        sh "minikube image load ${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }

    stage('Helm Deploy / Upgrade') {
      steps {
        echo "Deploying with Helm..."
        sh """
          helm upgrade --install ${APP_NAME} ${CHART_DIR} \
            --namespace ${K8S_NAMESPACE} \
            --set image.repository=${IMAGE_NAME} \
            --set image.tag=${IMAGE_TAG} \
            --set image.pullPolicy=IfNotPresent
        """
      }
    }

    stage('Verify') {
      steps {
        echo "Verify pods & services..."
        sh "kubectl get pods -n ${K8S_NAMESPACE} --selector=app=${APP_NAME} -o wide || true"
        sh "kubectl get svc -n ${K8S_NAMESPACE} --selector=app=${APP_NAME} || true"
      }
    }
  }

  post {
    success {
      echo "Deployment successful"
      // try to print a service URL (may fail if NodePort not exposed)
      sh "minikube service ${APP_NAME} -n ${K8S_NAMESPACE} --url || true"
    }
    failure {
      echo "Pipeline failed — check earlier logs"
    }
  }
}
