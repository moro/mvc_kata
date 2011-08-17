# -*- coding: utf-8 -*-
require 'mvc_kata/models'
require 'mvc_kata/views'
require 'mvc_kata/observer'

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
    include MvcKata::Observer

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
      loop do
        @player.action(command, @enemy).execute
        @enemy.action(nil, @player).execute
      end
    end

    def encounter
      @enemy = append_observer(Enemy.encounter.new)
      @view.encounter

      catch(:dead){ mainloop }
    end

    def start
      encounter()
    end

    def dead(ignore)
      throw :dead
    end

    private

    def append_observer(living)
      living.tap do |l|
        l.add_observer(@view)
        l.add_observer(self)
      end
    end
  end
end

