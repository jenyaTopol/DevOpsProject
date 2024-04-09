# DevOpsProject
kubectl create namespace jenkins
kubectl create namespace mysql

# Deploy mysql server and Jenkins as helm and 
helm install mysql bitnami/mysql --set mysqlRootPassword=rootPassword -n mysql
helm install jenkins-helm . -n jenkins --values values.yaml --debug
helm upgrade jenkins-helm . -n jenkins --values values.yaml --debug 

# Delete Jenkins server
helm delete jenkins-helm . -n jenkins

# Python Login-App
    deploy mysql server and fill the database.py configuration

    docker build . -t "image-name #dont forget to tag it.
    to check if the image is working with docker:
    run as docker:
        docker run -d -p 5000:5000 jenyat/python-flask-mysql:latest

FOR KUBENETES:
    install cert-manager to manage lets encrypt renewall of ssl certificates
    configure the nginx controller.

FOR JENKINS:   
    install roles rolebinding with the currect privligies and configure the names
    need to install /.kubec/config on master

FOR KUBERNETES-DASHBOARD:
    # Add kubernetes-dashboard repository
      helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    # Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
      helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
      create cluster-rolebinding.yaml and dashboard-user.yaml
      create token for authentication and sign-in
