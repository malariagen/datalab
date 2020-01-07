CLUSTERNAME="example"
GCP_ZONE="us-central1-f"

# create a cluster named ${CLUSTERNAME} in GCP zone ${GCP_ZONE}

###  CGP Zones

#asia-east1 			a, b, c 	Changhua County, Taiwan
#asia-east2 			a, b, c 	Hong Kong
#asia-northeast1 		a, b, c 	Tokyo, Japan
#asia-northeast2 		a, b, c 	Osaka, Japan
#asia-south1 			a, b, c 	Mumbai, India
#asia-southeast1 		a, b, c 	Jurong West, Singapore
#australia-southeast1 		a, b, c 	Sydney, Australia
#europe-north1 			a, b, c 	Hamina, Finland
#europe-west1 			b, c, d 	St. Ghislain, Belgium
#europe-west2 			a, b, c 	London, England, UK
#europe-west3 			a, b, c 	Frankfurt, Germany
#europe-west4 			a, b, c 	Eemshaven, Netherlands
#europe-west6 			a, b, c 	Zürich, Switzerland
#northamerica-northeast1 	a, b, c 	Montréal, Québec, Canada
#southamerica-east1 		a, b, c 	Osasco (São Paulo), Brazil
#us-central1 			a, b, c, f 	Council Bluffs, Iowa, USA
#us-east1 			b, c, d 	Moncks Corner, South Carolina, USA
#us-east4 			a, b, c 	Ashburn, Northern Virginia, USA
#us-west1 			a, b, c 	The Dalles, Oregon, USA
#us-west2 			a, b, c 	Los Angeles, California, USA

# GCP_ZONE should be set to e.g. europe-west1-a


gcloud container clusters create ${CLUSTERNAME}  --no-enable-legacy-authorization --num-nodes=4 --machine-type=n1-standard-2 --zone=${GCP_ZONE}


gcloud container clusters get-credentials ${CLUSTERNAME} --zone  ${GCP_ZONE} --project malariagen-jupyterhub

# create a pool of preemtible VMs in ${GCP_ZONE}
gcloud container node-pools create preemtible-pool --cluster ${CLUSTERNAME}  --zone ${GCP_ZONE} --scopes cloud-platform --enable-autoupgrade --preemptible --num-nodes 2 --machine-type n1-standard-8 --enable-autoscaling --min-nodes=0 --max-nodes=60 --node-taints preemptible=true:NoSchedule



# setup helm
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=kkluczynski@gmail.com
kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

# add Malariagen helm chart
helm repo add mgen https://malariagen.github.io/helm-charts
helm repo update
