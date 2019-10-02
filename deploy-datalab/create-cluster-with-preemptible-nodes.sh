gcloud container clusters create devcluster  --no-enable-legacy-authorization --num-nodes=4 --machine-type=n1-standard-2 --zone=us-central1-c

gcloud container node-pools create preemtible-pool --cluster devcluster  --zone us-central1-c --scopes cloud-platform --enable-autoupgrade --preemptible --num-nodes 2 --machine-type n1-standard-8 --enable-autoscaling --min-nodes=0 --max-nodes=60 --node-taints preemptible=true:NoSchedule


gcloud container clusters get-credentials devcluster  --zone us-central1-c --project malariagen-jupyterhub

# setup helm
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=kkluczynski@gmail.com
kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
