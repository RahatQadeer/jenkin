pipeline {
  agent any

  environment {
    IMAGE_NAME = "rahatqadeer/jenkin-demo"
    DOCKER_CRED = "docker-hub-creds"
    EC2_HOST = "15.134.36.98"   //  working EC2 public IP
    EC2_USER = "ubuntu"
    EC2_KEY = "ec2-ssh-key"     // Jenkins credential ID
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/RahatQadeer/jenkin.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def tag = new Date().format('yyyyMMddHHmmss')
          env.IMAGE_TAG = tag
          bat "docker build -t %IMAGE_NAME%:%IMAGE_TAG% ."
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          bat """
            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
            docker push %IMAGE_NAME%:%IMAGE_TAG%
            docker logout
          """
        }
      }
    }

 stage('Deploy to EC2') {
    steps {
        bat '''
        echo Deploying to EC2...
        ssh -o StrictHostKeyChecking=no -i "C:\\ProgramData\\Jenkins\\Jenkins-Rahat.pem" ubuntu@15.134.36.98 "sudo docker pull rahatqadeer/jenkin-demo:${BUILD_TIMESTAMP} && sudo docker stop myapp || true && sudo docker rm myapp || true && sudo docker run -d -p 80:80 --name myapp rahatqadeer/jenkin-demo:${BUILD_TIMESTAMP}"
        '''
    }
}


  }

  post {
    success {
      echo "Docker image built, pushed, and deployed successfully!"
    }
    failure {
      echo " Build failed!"
    }
  }
}
