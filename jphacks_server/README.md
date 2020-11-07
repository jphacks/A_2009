# Vele ServerSide README

<img src="app/assets/images/logo.png" width="480">

* Ruby version

  - 2.7.1

* フレームワーク

  - Ruby on Rails
  - Vue.js

* Ruby on Rails Version

  - 6.0.3.4

* Vue.js Version

  - 2.6.12

* 外部サービス

  - AWS S3

* 開発環境

  - Docker

* 主なライブラリ

  - Rails

    - slim (templateエンジン)
    - carrierwave (画像アップロード用)
    - rqrcode  (QRコード生成)
    - trestle  (管理画面)
  
  - Veu.js
  
    - materialize (CSSフレームワーク)
    - pug (templateエンジン)

* 環境構築

  ```bash
    $ bundle install -j4
    $ docker-compose up -d
    $ bundle exec rails s -b 0.0.0.0
    $ bin/webpack-dev-server
  ```
