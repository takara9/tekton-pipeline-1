# Tekton Pipeline と Trigger の連携

## セットアップ

IBM Cloudにアカウントを持っており、Kubernetesクラスタを起動して、以下のコマンドが実行可能なセットアップができている状態から記述していく。

~~~
$ ic ks clusters
~~~


kubectlとK8sクラスタのAPIサーバーと接続するためconfigをダウンロードする。

~~~
$ ic ks cluster config -c k8s-classic-tok04-2
~~~

Ingressコントローラーが起動していることを確認するために、クラスタの情報を表示して確認しておく。

~~~
$ ic ks cluster get -c k8s-classic-tok04-2
クラスター k8s-classic-tok04-2 を取得中...
OK
                                                 
名前:                                         k8s-classic-tok04-2   
ID:                                           bs2nodct0plqect47vqg   
状態:                                         normal   
作成:                                         2020-07-08T07:56:37+0000   
ロケーション:                                 tok04   
マスター URL:                                 https://c1.jp-tok.containers.cloud.ibm.com:22908   
パブリック・サービス・エンドポイント URL:     https://c1.jp-tok.containers.cloud.ibm.com:22908   
プライベート・サービス・エンドポイント URL:   -   
マスター・ロケーション:                       Tokyo   
マスター状況:                                 Ready (16 minutes ago)   
マスター状態:                                 deployed   
マスター正常性:                               normal   
Ingress サブドメイン:                         k8s-classic-tok04-2-dd3a245ee37e0f22836f16bc6000a054-0000.jp-tok.containers.appdomain.cloud   
Ingress の秘密:                               k8s-classic-tok04-2-dd3a245ee37e0f22836f16bc6000a054-0000   
Ingress 状況:                                 healthy   
Ingress メッセージ:                           All Ingress components are healthy   
ワーカー:                                     3   
ワーカー・ゾーン:                             tok04   
バージョン:                                   1.17.7_1529   
作成者:                                       -   
ダッシュボードのモニタリング:                 -   
リソース・グループ ID:                        6fcbec624d904ab19a28a1b75c58d467   
リソース・グループ名:                         default   

~~~

この時点で、ワーカーノードのリストを表示してみることができる。

~~~
$ kubectl get node
NAME            STATUS   ROLES    AGE     VERSION
10.192.31.215   Ready    <none>   10m     v1.17.7+IKS
10.192.31.223   Ready    <none>   9m59s   v1.17.7+IKS
10.192.31.228   Ready    <none>   9m34s   v1.17.7+IKS
~~~



## Tekconのインストール

以下のように、Tekton パイプラインとトリガーをインストールする。それからダッシュボードをインストールすると、ログの確認が容易になる。


~~~
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply -f https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml
~~~

これでネームスペースが追加され、その中でTektonのポッドが稼働する。

~~~
$ kubectl get ns
NAME               STATUS   AGE
default            Active   33m
ibm-cert-store     Active   29m
ibm-operators      Active   29m
ibm-system         Active   31m
kube-node-lease    Active   33m
kube-public        Active   33m
kube-system        Active   33m
tekton-pipelines   Active   15s

$ kubectl get pod -n tekton-pipelines
NAME                                           READY   STATUS    RESTARTS   AGE
tekton-pipelines-controller-79876fd95c-knqdl   1/1     Running   0          5m20s
tekton-pipelines-webhook-5585867b79-9kzmx      1/1     Running   0          5m19s
tekton-triggers-controller-7796888967-ngw4x    1/1     Running   0          5m17s
tekton-triggers-webhook-68cb768d5c-hrcwz       1/1     Running   0          5m17s
~~~

Tekton パイプラインへ進む


