podTemplate(containers: [
    containerTemplate(
        name: 'jnlp',
        image: 'jenkins/inbound-agent:latest'
    ),
    containerTemplate(
        name: 'docker',
        image: 'docker:latest',
        command: 'cat',
        ttyEnabled: true,
        privileged: true 
    ),
    containerTemplate(
        name: 'git',
        image: 'alpine/git', 
        command: 'cat',
        ttyEnabled: true
    )
]) {
    node(POD_LABEL) {
        stage('Clone Repository') {
            container('git') {
                withCredentials([usernamePassword(credentialsId: 'githubCredentialsId', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                    def branch = 'main'
                    sh "git clone -b $branch https://$GIT_USERNAME:$GIT_PASSWORD@github.com/jenyat/python-flask-mysql.git ."
                }
            }
        }

        stage('Build and Push Docker Image') {
            container('docker') {
                withCredentials([usernamePassword(credentialsId: 'dockerhubCredentialsId', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    stage('Login to DockerHub') {
                        sh "echo \$DOCKERHUB_PASSWORD | docker login --username \$DOCKERHUB_USERNAME --password-stdin"
                    }
                    stage('Build Docker Image') {
                        def imageName = 'jenyat/python-flask-mysql'
                        def tag = 'latest'
                        sh "docker build -t \$imageName:\$tag ."
                    }
                    stage('Push Image to DockerHub') {
                        def imageName = 'jenyat/python-flask-mysql'
                        def tag = 'latest'
                        sh "docker push \$imageName:\$tag"
                    }
                }
            }
        }
    }
}
