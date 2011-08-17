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
      @player = append_observer(Player.new)
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

        if @enemy.living?
          @enemy.attack(@player)
        end
      end
    end

    def encounter
      @enemy = append_observer(Enemy.encounter.new)
      @view.encounter

      mainloop
    end

    def start
      encounter()
    end

    private

    def append_observer(living)
      living.tap {|l| l.add_observer(@view) }
    end
  end
end

