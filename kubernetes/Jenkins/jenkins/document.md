helm install jenkins-helm . -n jenkins --values values.yaml --debug
helm upgrade jenkins-helm . -n jenkins --values values.yaml --debug 
helm delete jenkins-helm . -n jenkins