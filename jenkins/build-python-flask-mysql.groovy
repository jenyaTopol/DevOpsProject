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
    )
]) {
    node(POD_LABEL) {
        stage('Get a shell command') {
            container('jnlp') {
                stage('Shell Execution') {
                    sh 'echo "Hello! I am executing shell"'
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
                        // Adjust the 'imageName' and 'tag' as necessary
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
