# 【生配信ハンズオン】CircleCIでCI入門【サポーターズCoLab】

## 講師

+ 宇山慎二さん

## Agenda

+ CIとは?
+ CircleCiとは?
+ CircleCiのハンズオン
+ CircleCiのTips
+ まとめ

## 対象

+ 初心者向け

## ハンズオンのゴール

+ CircleCIを使って，PR作成時にテストを実行し，結果を表示するCIフローを作成

## CIとは?

+ 継続的インテグレーション
+ XPの開発手法の一つ
+ コードを常にビルド/テストし続けることで問題の発見を迅速に行い，常にソフトウェアを健全な状態に保つことを目的とした開発手法

### 活用例

+ プルリクエスト作成時や本番デプロイ前にテストやLintを実行
+ プルリクエスト画面で実行結果を確認できる

### 導入のメリット

+ コードの品質を落とす事象を見落とすことなく，すぐに気がつける
+ テスト結果が可視化されるので，テスト作成への意識が高まる

## CircleCIとは?

+ CIのツールの一つ．GitHub Actionsなども．
+ Saasサービスで，簡単に導入できる

### 料金体系

+ 基本的に無料で使える
+ 無料だと，1コンテナまで同時に実行できる．実行時間の制限がある(25h/week)
+ 有料プランもある

## ハンズオン

1. テストコードの作成
2. GitHubレポジトリとCircleCIを連携
3. git push時にテストを実行するCIフローを作成
4. CIの動作を確認
    a. テストが失敗する場合
    b. テストが成功する場合

### テストコードの作成

+ レポジトリを用意
+ 2つの整数の足し算をするプログラムと，テストコードを用意

### GitHubレポジトリとCircleCIを連携

+ ログイン
+ [CircleCI](https://circleci.com/)にアクセス
+ ADD PROJECTSタブで，該当するレポジトリを選択し，Set Up Projectのボタンを押す
  + OSや言語を選択すると，設定ファイルのサンプルが作成される
  + Next Stepsの5. Start buildingを押す
  + 設定ファイルがないというエラーが出る

### git push時にテストを実行するCIフローを作成

+ CircleCIの設定ファイルが必要
  + アプリのルートディレクトリの直下に'.circleci/config.yaml'を配置
  + 設定ファイルの作成
    + インデントが意味を持つ

```yml
# Minmum settings
# CircleCI version
version: 2.1

# Unit of CI flow
# Write jobs setting
# The following sample runs tests.
jobs:
  test:
    # Use official Docker image
    docker:
      - image: circleci/ruby:2.6.3
    # root dir
    working_directory: ~/repo
    # Use latest code
    steps:
      - checkout
      - run:
          name: Run test
          command: ruby test/sum_test.rb

# The order of CI flows
workflows:
  version: 2
  workflows:
    jobs:
      - test

```

### 動作確認

+ ローカル環境で，テストが通ることを確認
+ GitHubのPRを送ると，CircleCIでテストが実行される

## CircleCiのTips

+ 複数のワークフローを扱う場合

```yml
# フローを並列実行
jobs:
  ...
  code-check:
    ...
    steps:
      - checkout
      - run:
          command: bundle install --path vender/bundle
      - run:
          command: bundle exec rubocop

workflows:
  version: 2
  workflows:
    # 以下の部分に，フローを追加
    jobs:
      - test
      - code-check

# フローを直列実行
workflows:
  version: 2
  workflows:
    # buildが完了してから，testとcode-checkを実行
    jobs:
      - build
      - test:
          requires:
            - build
      - code-check:
          requires:
            - build

# 特定のブランチへのPushのみ実行させたい
# productionブランチの場合
workflows:
  version: 2
  workflows:
    jobs:
      - deployment:
          filters:
            branches:
                only: production

# DBを使う場合
# DB用のイメージを追加
# 環境変数の追加は，専用の設定箇所に．
# Jobsの該当プロジェクトの設定ボタンをクリック，Environment Variablesを選択
test:
  docker:
    - image: $CONTAINER_IMAGE:test-$CIRCLE_SHA1
      environment:
        RAILS_ENV: test
        DATABASE_HOST: 127.0.0.1
        DATABASE_USER: root
        DATABASE_PASSWORD: password
        DOCKERIZE_VERSION: v0.6.1
    - image: circleci/mysql:5.7
      environment:
        MYSQL_ROOT_PASSWORD: password
```

## Summary

+ アプリケーションに対するテストコードを用意
+ アプリケーションをCircleCIと連携
  + 公式HPにログイン
  + CIを実行するプロジェクトを選択
  + 設定ファイルをyml形式で書く
  + commit & push
  + PRを作成
  + 結果を確認

## Comment

+ 講師の資料・プレゼン・サンプルが優れているのはあるが，思っていた以上に簡単に導入できそうな感じ
+ テストケースを先に書いてPRでレビューを受けるのも有効，とあり試してみようと思った
+ 自分のアプリケーションにCIを導入してみる

## URL

+ https://www.youtube.com/watch?v=sDehZR6Cqo8&feature=youtu.be

+ https://ushinji.hatenablog.com
