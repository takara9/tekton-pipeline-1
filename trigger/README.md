# Tekton Trigger を追加


サービスアカウントとアクセス権限の追加

~~~
kubectl apply -f trigger-admin-role.yaml
kubectl apply -f trigger-webhook-role.yaml
~~~

トリガーの設定で、利用者自身のカスタマイズやパイプラインの変更などは、このファイルに実施する

~~~
kubectl apply -f triggers.yaml
~~~

イベントリスナーに必要なタスクを設定する。

~~~
kubectl apply -f trigger-create-ingress.yaml
kubectl apply -f trigger-create-webhook.yaml
~~~

イングレスを起動して、クラスター外からリクエストを受けられるようにする。
以下の例は、Classic Infrastructure 上のKubernetesでの例であるが、VPC上でも同じ。

~~~
kubectl apply -f trigger-ingress-run.yaml

kubectl get ing
NAME               HOSTS                                                                                       ADDRESS   PORTS     AGE
el-cicd-listener   k8s-classic-tok04-dd3a245ee37e0f22836f16bc6000a054-0000.jp-tok.containers.appdomain.cloud   128.168.66.131   80, 443   0s
~~~

GitHubで生成したトークンと、TektonとGitHubで共有する文字列であるシークレット

~~~
kubectl apply -f trigger-secret-github.yaml
~~~

GitHubのユーザーなど、WebHookを飛ばしてくる元の情報をセット

~~~
kubectl apply -f trigger-webhook-run.yaml
~~~


## テスト方法

開発対象のリポジトリをクローンして、
次のコマンドで、そのままコードの修正なしで、プッシュしてWebhookを発動できる。

~~~
git clone https://github.com/takara9/web-nginx
cd web-nginx
git commit -a -m "build commit" --allow-empty && git push 
~~~

