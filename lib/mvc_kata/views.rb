# coding: utf-8
require 'forwardable'

module MvcKata
  module View
    BLANKLINE_RE = /\A\s+\Z/
    def unindent(string)
      trim = string.lines.reject {|l| l =~ BLANKLINE_RE }.map {|l| l[/^ +/].size }.min
      string.lines.map {|l| l =~ BLANKLINE_RE ? l : l[trim, l.length] }.join
    end

    class Base
      extend Forwardable
      include View

      def_delegators '@battle', :player, :enemy

      def initialize(battle)
        @battle = battle
      end

      def update(method, *values)
        return false unless respond_to?(method)
        send(method, *values)
      end

      def dead(is_enemy)
        is_enemy ? finish_battle : game_over
      end

      def render(output, prompt = false)
        puts unindent(output)
        wait unless prompt
      end

      def wait
        $stdin.gets
      end

      def get_command
        v = $stdin.gets.strip
        v == '2' ? :hoimi : v
      end
    end


    class Ja < Base
      def get_command
        (v = super) == 'ホイミ' ? :hoimi : v
      end

      def query_command
        render(<<-VIEW, true)
          ===========================
          #{player.name}のHP: #{player.hp}
           1 たたかう"
           2 ホイミ"
          コマンド? [1]
        VIEW
      end

      def encounter
        render(<<-VIEW)
          ===========================
          #{enemy.name}があらわれた

        VIEW
      end

      def attacked(attacker, victim, damage)
        render(<<-VIEW)
          ===========================
          #{attacker.name}のこうげき
          #{victim.name}に#{damage}のダメージ
        VIEW
      end

      def player_hoimi(cure_point)
        render(<<-VIEW)

          ===========================
          #{player.name}はホイミをとなえた
          HPが#{cure_point}回復した
        VIEW
      end

      def finish_battle
        render(<<-VIEW)
          #{enemy.name}をたおした

          ===========================
          かかったターン数#{@battle.turn_count}
          経験値#{enemy.exp}かくとく"
        VIEW
      end

      def game_over
        render(<<-VIEW)
          #{player.name}はたおれました

          ===========================
          ゲームオーバー
        VIEW
      end
    end

    class En < Base
      def get_command
        (v = super) == 'Hoimi' ? :hoimi : v
      end

      def query_command
        render(<<-VIEW, true)

          ===========================
          #{player.name} HP: #{player.hp}
           1 Attack
           2 Hoimi
          Command? [1]
        VIEW
      end

      def encounter
        render(<<-VIEW)
          ===========================
          #{player.name} encountered a #{enemy.name}.
        VIEW
      end

      def attacked(attacker, victim, damage)
        render(<<-VIEW)

          ===========================
          #{attacker.name} attack.
          #{victim.name} damaged #{damage} point(s).
        VIEW
      end

      def player_hoimi(cure_point)
        render(<<-VIEW)

          ===========================
          #{player.name} call hoimi.
          #{player.name} cured #{cure_point} point(s)
        VIEW
      end

      def finish_battle
        render(<<-VIEW)
          #{player.name} win!

          ===========================
          Turn count: #{@battle.turn_count}
          #{player.name} get #{enemy.exp} EXP
        VIEW
      end

      def game_over
        render(<<-VIEW)
          #{player.name} lose...

          ===========================
          GAME OVER"
        VIEW
      end
    end
  end
end
