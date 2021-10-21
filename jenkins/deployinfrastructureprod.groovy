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
                dir("terraform/dev"){
                    sh "terraform init -migrate-state"
                }
            }
        }


        stage('Plan terraform') {
            steps {
                dir("terraform/prod"){
                    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'C_PASS', usernameVariable: 'C_USER')]) {
                        script {
                            try {
                                sh """
                                terraform plan -var-file="tfvars/prod.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "imageName=${imageName}" -var "instance_label=${application_label}"
                                """
                            }
                            catch (Exception ex) {
                                println(ex.getMessage())
                                if (ex.getMessage().contains("-migrate-state")){
                                    sh """
                                    terraform init -migrate-state
                                    terraform plan -var-file="tfvars/prod.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "imageName=${imageName}" -var "instance_label=${application_label}"
                                    """
                                }
                                else {
                                    sh """
                                    terraform init -migrate-state
                                    terraform plan -var-file="tfvars/prod.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "imageName=${imageName}" -var "instance_label=${application_label}"
                                    """
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Apply terraform') {
            steps {
                dir("terraform/prod"){
                    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'C_PASS', usernameVariable: 'C_USER')]) {
                        sh """
                         terraform apply -var-file="tfvars/prod.tfvars" -var "docker_pass=${C_PASS}" -var "docker_login=${C_USER}" -var "imageName=${imageName}"  -var "instance_label=${application_label}" -auto-approve
                         """
                    }
                }
            }
        }
    }
}