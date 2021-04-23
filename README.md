# ansible-for-wordpress

本リポジトリには、スタンドアローンな WordPress 環境を構築するための Playbook が内包します。

以下へ、本リポジトリの Playbook を利用して WordPress 環境を EC2 上へデプロイする手順と、Docker 上のコンテナへデプロイする手順をを記載します。

<br>

## 注意
インストールパッケージ等のバージョンについて、あまり冪等性は考慮されていません。

<br>

## 前提条件
OS: Amazon Linux 2  
実行ユーザ：root

<br>

## EC2環境に構築する場合
### 環境セットアップ

1. yum リポジトリ＆パッケージのアップデート
    ```
    # yum update
    ```
2. ansible2 を有効化
    ```
    # amazon-linux-extras enable ansible2
    ```
3. Ansible のインストール
    ```
    # yum clean metadata
    # yum install ansible
    ```

<br>

### Playbook の実行

4. リポジトリを clone する
    ```
    # git clone {本リポジトリ}
    ```
5. Playbook の実行
    ```
    # cd {本リポジトリ}/
    # ansible-playbook playbook.yml
    ```
6. ブラウザで WordPress へ接続し初期セットアップ
    ```
    http://{wordpress/url}
    ```

<br>

## Docker環境に構築する場合
下記手順に登場する Docker イメージやコンテナの「タグ名」には好きなものをチョイスして下さい。

<br>

### Docker イメージのビルドと、コンテナの作成＆起動

1. リポジトリを clone する
    ```
    $ git clone {本リポジトリ}
    ```
2. 既存イメージでは systemctl が利用できないので、自作の Dockerfile から Docker イメージをビルド
    ```
    $ cd {/path/to/repository}/
    $ docker build -t amazonlinux2/custom:latest .
    ```
3. リポジトリをコンテナへマウントしつつコンテナを作成＆起動
    ```
    $ docker run -d --privileged --name amazonlinux -p 8080:80 -v {/path/to/repository}:/mnt amazonlinux2/custom:latest /sbin/init
    ```

<br>

### Playbooke の実行

4. コンテナへ接続
    ```
    $ docker exec -it amazonlinux /bin/bash
    ```
5. リポジトリをマウントした場所へ移動し、Playbook を実行
    ```
    # cd /mnt/
    # ansible-playbook playbook.yml
    ```
6. ブラウザで WordPress へ接続し初期セットアップ
    ```
    http://localhost:8080
    ```