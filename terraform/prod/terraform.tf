terraform {

    backend "artifactory" {
        url = "http://ec2-3-70-136-183.eu-central-1.compute.amazonaws.com:8081/repository"
        repo = "releases"
        subpath = "2/prod"
        username = "jenkins"
        password = "Xitenavge49"
    }
}