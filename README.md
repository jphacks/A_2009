# Vele

[![IMAGE ALT TEXT HERE](jphacks_server/app/assets/images/logo.png)](https://youtu.be/whqDKI75sJM)

## 製品概要
### 背景(製品開発のきっかけ、課題等）
ゼミや学会のオンライン開催が多くなり，オンラインによるプレゼンの機会が増えています．しかし，発表者がプレゼンしやすいように聴講者は画面や音を消した結果，一方通行的な発表になってしまっている側面があります．また，発表者からしたら相槌がないため自分の発表がどう思われているのか分からず不安になり，聴講者も発言のタイミングが難しく，質問する機会を逃してしまったという経験は誰しもがしたことがあるのではないのでしょうか．せっかくオンラインにより現地にいく必要がなくなり，多くの制約が消えるというメリットがあるにもかかわらず，一方通行な発表になるのはもったいないと考えます．
そんなオンラインプレゼンに対する課題を解決するために発表者と聴講者の間で質問などのやり取りがスムーズになり，なんなら今までよりも心の距離が近くなるプレゼンができるようなアプリを作りたいと思いました．

### 製品説明（具体的な製品の説明）
発表者が自分の発表資料をWebアプリに上げるとQRコードが発行され，それを聴講者に表示することで聴講者はアプリを通して発表者の資料を見ることができます．さらに，聴講者は各スライドに対していつでもコメントができ，そのコメントはリアルタイムで同じスライドを見ている人に伝わっていきます．

### 特長
#### 1. 特長1
匿名式により質問がしやすくなります．具体的には，学会などで偉い教授がいるときにこんな質問していいのかなんて思って質問できなかったことはありませんか？匿名なのでそんな心配なく気軽に質問できるようなります．そして，スライド毎にスレッド形式で質問やコメントができるので，どのスライドで質問したかが分かりやすくなっており，議論が弾むことでしょう．

#### 2. 特長2
発表者はPCから直接資料をアップロードできるWebアプリを、聴講者はPCをZoomなどで使っていると想定し，モバイル端末で操作できるアプリにしました．これらのプラットフォームをそれぞれ用いることで発表者と聴講者がお互いに負担を減らせると考えました．

#### 3. 特長3
クロスプラットフォーム対応によりiOS，Androidどちらでもアプリをダウンロードできるようにしました．

### 解決出来ること
・一方通行になりがちなオンライン発表を双方向なものへと発展させることができます．
・質問やプレゼン資料は履歴から見直せるため，振り返りが簡単にできます．

### 今後の展望
・スライドのサムネイルを表示させる
・収益化（スライド枚数やアクセス人数の制限解除などの課金要素）

### 注力したこと（こだわり等）
* バックエンド
  - 資料を共有するまでの流れを簡素にしたこと
  - nativeの開発者がデータを触れるように管理画面を生成したこと

* Flutter
  - パフォーマンスを考えて通信回数を最小化
  - シンプルなUI・UX
  - Lintでチーム内のコードを統一

## 開発技術
### 活用した技術
#### フレームワーク・ライブラリ・モジュール
* Ruby on Rails (バックエンド) [詳細](https://github.com/jphacks/A_2009/blob/server_master/jphacks_server/README.md)
* Vue.js (Webフロントエンド) - [ディレクトリ](https://github.com/jphacks/A_2009/tree/server_master/jphacks_server/app/frontend)
* Flutter
  - sqlite

- DB
  - MySQL ver5.7
- 開発環境
  - Docker
- 外部サービス
  - AWS S3


#### デバイス
* Native (iOS・Android)
* Webブラウザ

### 独自技術
#### ハッカソンで開発した独自機能・技術
- バックエンド
  - AWS S3にPDFファイルのアップロード処理
  - QRコードの表示
  - 管理画面の作成
  - templateエンジンをslimとpugを利用することでなるべく簡単に開発できるようにしたこと

#### 担当

- バックエンド・Webフロント
  - [@gonzaemon111](https://github.com/gonzaemon111)
- モバイルアプリ
  - [@akio-yamashita](https://github.com/akio-yamashita)
  - [@shun0729](https://github.com/shun0729)
