# Docker+PyTorch(GPU)環境構築

以下開発環境を構築するファイル一式です。

- WSL2+Ubuntu24.04上で動作するDockerコンテナ
  - NVIDIA GPUでアクセラレートできるPyTorchが動作
  - 現在のユーザー権限で動作
  - コンテナ内ホームディレクトリのデータ永続化（コンテナを停止してもデータが消えない）

| ファイル | 説明 |
|:-|:-|
| Dockerfile | dockerコンテナをビルドするためのMakefile |
| container_init.sh | コンテナ起動時にコンテナ内で実行されるシェルスクリプト |
| docker_build.sh | docker buildコマンドを実行するシェルスクリプト。現在のユーザーID等をコンテナに付与 |
| docker_run.sh | docker runコマンドを実行するシェルスクリプト。ホームディレクトリのマウント等も実施 |

上述ファイルには、以下PC環境向けの設定が書かれてます。
- GPU: NVIDIA GeForce GTX 1660 SUPER
- OS: Windows 11 Home (23H2） , WSL2 + Ubuntu24.04

PC環境（GPU）依存箇所は「★★★」コメントを入れてありますので、各々の環境に合わせてカスタマイズしてご利用ください。
カスタマイズ方法は、以下記事をご覧ください。

[WSL2にDocker+PyTorch(GPU)環境を構築](https://qiita.com/shima202102/items/7296d8a1e27193631b56)

## 使い方

WSL2 Ubuntuターミナルで以下実施。

```sh
# dockerコンテナビルド
./docker_build.sh

# dockerコンテナ起動
./docker_run.sh
```

コンテナ起動すると、カレントディレクトリに ```/home/$USER``` というディレクトリが作成されます。

コンテナ内のホームディレクトリにマウントされているので、ここでコンテナとのファイルのやり取りが可能です。また、コンテナを停止してもファイルが消えずに残ります。




