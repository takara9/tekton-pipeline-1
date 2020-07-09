専用に名前空間を作ってデフォルトを切り変える

~~~
kubectl create ns cicd
kubectl config get-contexts | grep `kubectl config current-context`
kubectl config set-context cicd --namespace=cicd --cluster=<CLUSTER> --user=<AUTHINFO> 
kubectl config use-context cicd
kubectl config get-contexts
~~~

レジストリサービスへアクセスするトークンを名前空間default から cicd へコピーする。

~~~
kubectl get secret all-icr-io -n default -o yaml | sed 's/default/cicd/g' | kubectl create -n cicd -f -
kubectl patch -n cicd serviceaccount/default -p '{"imagePullSecrets":[{"name": "all-icr-io"}]}'
kubectl describe sa default
~~~

パイプラインのタスクとパイプラインを設定する

~~~
cd pipeline
kubectl apply -f task-git-clone.yaml
kubectl apply -f task-kaniko.yaml
kubectl apply -f task-deploy-using-kubectl.yaml 
kubectl apply -f pipeline-build-and-deploy.yaml
~~~

レジストリサービスにイメージを登録するための設定追加

~~~
kubectl create secret generic ibm-registry-secret \
--type="kubernetes.io/basic-auth" \
--from-literal=username=iamapikey \
--from-literal=password=OaO**************************************rsd

kubectl annotate secret ibm-registry-secret tekton.dev/docker-0=jp.icr.io
~~~


ワークスペース用のストレージ作成、そして、サービスアカウントと権限の付与

~~~
kubectl apply -f pipeline-ws-pvc.yaml
kubectl apply -f pipeline-sa-and-rbac.yaml
~~~

Tektonパイプラインのテスト実行

~~~
kubectl apply -f pipelinerun-apl.yaml
~~~

確認方法で pipelinerun が成功終了になる必要がある。

~~~
kubectl get pipelinerun
kubectl get pod -w
~~~

次のコマンドは、Tekton専用のtknコマンドで、kubectl同様にワークステーション側にインストールする必要がある。

~~~
tkn pipelinerun describe webapl
~~~