pipeline {
    agent any

    environment {
        // 환경 변수 설정
        DOCKER_IMAGE = 'lucky-nginx'
        KUBECONFIG = '~/.kube/config'
        DEPLOYMENT_NAME = 'nginx-deployment'
        NAMESPACE = 'kube-system'
    }

    triggers {
        // SCM 폴링을 통해 주기적인 리포지토리 체크
        pollSCM('H/1 * * * *')  // 매 1분마다 폴링
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-jenkins', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker build -t $USERNAME/${DOCKER_IMAGE} ."
                        sh "docker login -u $USERNAME -p $PASSWORD"
                        // Docker 이미지 푸시
                        sh "docker push $USERNAME/${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh 'kubectl rollout restart -f deployment.yaml --kubeconfig=$KUBECONFIG'
                    }
                }
            }
        }
    }

    post {
        always {
            // 로그 정리나 후처리 작업
            echo 'Pipeline execution complete!'
        }
    }
}
