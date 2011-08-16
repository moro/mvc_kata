# coding: utf-8
require 'forwardable'

module ViewContext
  BLANKLINE_RE = /\A\s+\Z/
  def unindent(string)
    trim = string.lines.reject {|l| l =~ BLANKLINE_RE }.map {|l| l[/^ +/].size }.min
    string.lines.map {|l| l =~ BLANKLINE_RE ? l : l[trim, l.length] }.join
  end

  class Ja
    extend Forwardable
    include ViewContext

    def_delegators '@battle', :player, :enemy

    def initialize(battle)
      @battle = battle
    end

    def update(method, *values)
      return false unless respond_to?(method)
      send(method, *values)
    end

    def query_command
      puts unindent(<<-VIEW)
        ===========================
        #{player.name}のHP: #{player.hp}
         1 たたかう"
         2 ホイミ"
        コマンド? [1]
      VIEW
    end

    def encounter
      puts unindent(<<-VIEW)
        ===========================
        #{enemy.name}があらわれた

      VIEW
    end

    def attacked(attacker, victim, damage)
      puts unindent(<<-VIEW)
        ===========================
        #{attacker.name}のこうげき
        #{victim.name}に#{damage}のダメージ
      VIEW
    end

    def player_hoimi(cure_point)
      puts unindent(<<-VIEW)

        ===========================
        #{player.name}はホイミをとなえた
        HPが#{cure_point}回復した
      VIEW
    end

    def finish_battle
      puts unindent(<<-VIEW)
        #{enemy.name}をたおした

        ===========================
        かかったターン数#{@battle.turn_count}
        経験値#{enemy.exp}かくとく"
      VIEW
    end

    def game_over
      puts unindent(<<-VIEW)
        #{player.name}はたおれました

        ===========================
        ゲームオーバー
      VIEW
    end
  end
end
