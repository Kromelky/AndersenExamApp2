pipeline {

    agent any

    environment {
        registryCredentials = "nexus-jenkins-acc"
        registry = "10.0.0.179:8085/"
        repo = "https://github.com/Kromelky/AndersenExamApp2"
        imageName = 'kromelky/application2'
        gitHubAuthId = 'git-kromelky-token'
        nexus_login = "nexus-acc"
        application_label = "2"
    }


    stages {
        stage('Init terraform') {
            steps {
                dir("terraform"){
                    sh "terraform init"
                }
            }
        }

        stage('Plan terraform') {
            steps {
                dir("terraform"){
                    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'C_PASS', usernameVariable: 'C_USER')]) {
                        sh """
                        terraform plan -var-file="tfvars/dev.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "instance_label=${application_label}" -var "imageName=${imageName}"
                        """
                    }
                }
            }
        }

        stage('Apply terraform') {
            steps {
                dir("terraform"){
                    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'C_PASS', usernameVariable: 'C_USER')]) {
                        sh """
                         terraform apply -var-file="tfvars/dev.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "instance_label=${application_label}" -var "imageName=${imageName}" -auto-approve
                         """
                    }
                }
            }
        }
    }
}