# -*- coding: utf-8 -*-
require 'mvc_kata/models'
require 'mvc_kata/views'

module MvcKata
  class Runner
    def initialize(args)
      view = (args.shift == "english") ? View::En : View::Ja
      @battle = Battle.new(view)
    end

    def run
      @battle.start
    end
  end

  class Battle
    attr_reader :player, :enemy, :turn_count
    def initialize(view_class)
      @view = view_class.new(self)
      @player = Player.new([@view])
      @turn_count = 0
    end

    def command
      @turn_count += 1
      @view.query_command
      @view.get_command
    end

    def mainloop
      while (@player.living? && @enemy.living?) do
        case command
        when :hoimi then @player.cure(8)
        else @player.attack(@enemy)
        end

        wait

        if @enemy.living?
          @enemy.attack(@player)
          wait
        end
      end
    end

    def encounter
      enemy_klass = Enemy.encounter
      @enemy = enemy_klass.new([@view])
      @view.encounter

      wait
      mainloop

      @player.living? ?  @view.finish_battle : @view.game_over
      wait
    end

    def start
      encounter()
    end

    private

    def wait
      @view.wait
    end
  end
end

