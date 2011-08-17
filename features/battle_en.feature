# language: ja
フィーチャ: ドラクエ風戦闘は英語でも使える
  ゲーム提供もととして、
  この素晴らしいゲームを英語にも訳したい
  北米・ヨーロッパ市場で売りまくってバンバンや!!

  シナリオ: ドラゴンと戦って、敗北する
    前提    ランダム値を以下のとおり固定する:
      | 敵     | ダメージ |
      | Dragon | 2        |
    かつ    英語モードで起動する
    もし    以下のコマンドを入力する:
      | コマンド |
      | Attack |
      | Attack |
      | Hoimi  |
      | Attack |
      | Attack |
      | Attack |

    ならば  標準出力に次のとおり表示されていること:
    """
PLAYER encountered a DRAGON.

===========================
    """

    かつ  標準出力に次のとおり表示されていること:
    """
===========================
PLAYER call hoimi.
PLAYER cured 2 point(s)

===========================
DRAGON attack.
PLAYER damaged 2 point(s).

===========================
PLAYER HP: 6
    """

    かつ  標準出力に次のとおり表示されていること:
    """
===========================
DRAGON attack.
PLAYER damaged 2 point(s).
PLAYER lose...

===========================
GAME OVER
    """

