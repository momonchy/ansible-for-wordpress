# ansible-for-wordpress

本リポジトリには、スタンドアローンな WordPress 環境を構築するための Playbook が内包します。  
以下へ、EC2 と Docker 環境上で Playbook を実行する手順を記載します。

<br>

## 注意
- インストールパッケージバージョンの互換性について、冪等性等はあまり考慮されていません
- DB認証情報については以下二点を編集して下さい（要見直し）
    - ```roles > mariadb > vars > main.yml```
    - ```roles > wordpress > files > wp-config.php.patch```

<br>

## 前提条件
OS: Amazon Linux 2  
実行権限：(#)はroot権限、($)は一般ユーザ権限

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
5. Database 設定情報の変更
    ```
    # cd {本リポジトリ}/
    # vim playbook.yml
    ```
6. Playbook の実行
    ```
    # ansible-playbook playbook.yml
    ```
7. ブラウザで WordPress へ接続し初期セットアップ
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
5. リポジトリをマウントした場所へ移動し、Database 設定情報の変更
    ```
    # cd /mnt/
    # vim playbook.yml
    ```
6. Playbook を実行
    ```
    # ansible-playbook playbook.yml
    ```
7. ブラウザで WordPress へ接続し初期セットアップ
    ```
    http://localhost:8080
    ```