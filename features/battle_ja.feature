# language: ja
フィーチャ: ドラクエ風の戦闘ができる
  ゲームのプレイヤーとして、
  ドラクエ風の戦闘がしたい。
  なぜなら、昭和生まれにとってゲームといえばドラクエだからだ

  シナリオ: ドラゴンと戦って、敗北する
    前提    `ruby -I../../lib -r../../fixrand.rb ../../bin/mvc_kata`を対話的に実行する
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"
    もし    I type "1"

    ならば  標準出力に次のとおり表示されていること:
    """
DRAGONがあらわれた

===========================
    """
    かつ  標準出力に次のとおり表示されていること:
    """
===========================
DRAGONのこうげき
PLAYERに2のダメージ
PLAYERはたおれました

===========================
ゲームオーバー
    """
