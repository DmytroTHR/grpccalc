pipeline{
    agent any

    stages{
        stage('Build docker image'){
            steps{
                sh 'docker build . -t calc_client --target calc_client'
                sh 'docker build . -t calc_server --target calc_server'
            }
        }
    }
}