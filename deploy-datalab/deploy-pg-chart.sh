#gcloud container clusters create malariagen --no-enable-legacy-authorization  --scopes "https://www.googleapis.com/auth/cloud-platform"  --num-nodes=3 --machine-type=n1-standard-2 --zone=us-central1-a 
#--cluster-version "1.10.6-gke.2" 
  gcloud container clusters get-credentials malariagen --zone us-central1-a --project malariagen-jupyterhub


exit 0

# set up helm

  kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=googlecloud@malariagen.net
  kubectl --namespace kube-system create sa tiller
  kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
  helm init --service-account tiller
  kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

  helm repo add mgen https://malariagen.github.io/helm-charts
  helm repo update
