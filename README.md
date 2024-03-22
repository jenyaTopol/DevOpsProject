# DevOpsProject
kubectl create namespace mysql

# Deploy mysql server as helm
helm install mysql bitnami/mysql --set mysqlRootPassword=rootPassword -n mysql

# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard


helm install jenkins-helm . -n jenkins --values values.yaml --debug
helm upgrade jenkins-helm . -n jenkins --values values.yaml --debug 
helm delete jenkins-helm . -n jenkins


FOR KUBENETES:
    install cert-manager to manage lets encrypt renewall of ssl certificates
    configure the nginx controller.

FOR JENKINS:   
    install roles rolebinding with the currect privligies and configure the names
    need to install /.kubec/config on master

FOR KUBERNETES-DASHBOARD:
    INSTALL cluster role and role binding and create authentication-done
    token and save it as kubenetes secret
