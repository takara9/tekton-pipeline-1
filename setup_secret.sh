kubectl create secret generic ibm-registry-secret \
	--type="kubernetes.io/basic-auth" \
	--from-literal=username=iamapikey \
	--from-literal=password=<APIKEY>

kubectl annotate secret ibm-registry-secret tekton.dev/docker-0=jp.icr.io
