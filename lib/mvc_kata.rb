# -*- coding: utf-8 -*-
require 'dice'
require 'living'
require 'view'

class Battle
  attr_reader :player, :enemy, :turn_count
  def initialize(view_class)
    @view_context = view_class.new(self)
    @enemy_classes = [Slime, Dragon]
    @player = Player.new([@view_context])
    @turn_count = 0
  end

  def command
    @turn_count += 1
    @view_context.query_command
    @view_context.get_command
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
    @enemy = Dice.shuffle(@enemy_classes).new([@view_context])
    @view_context.encounter

    wait
    mainloop

    @player.living? ?  @view_context.finish_battle : @view_context.game_over
    wait
  end

  def start
    encounter()
  end

  private

  def wait
    @view_context.wait
  end
end

