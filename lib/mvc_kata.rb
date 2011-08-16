# -*- coding: utf-8 -*-
require 'dice'
require 'living'
require 'view'

class Battle
  attr_reader :player, :enemy, :turn_count
  def initialize
    @view_context = ViewContext::Ja.new(self)
    @enemy_classes = [Slime, Dragon]
    @player = Player.new([@view_context])
    @turn_count = 0
  end

  def command
    @turn_count += 1
    @view_context.query_command

    $stdin.gets.strip
  end

  def mainloop
    while (@player.living? && @enemy.living?) do
      case command
      when "ホイミ", "2" then @player.cure(8)
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
    $stdin.gets.strip
  end
end

class BattleEnglish
  def initialize
    @enemy_classes = [Slime, Dragon]
    @player = Player.new
    @turn_count = 0
  end

  def finish_battle
    puts "#{@player.name} win!"

    puts
    puts "==========================="
    puts "Turn count: #{@turn_count}"
    puts "#{@player.name} get #{@enemy.exp} EXP"

    gets
  end

  def check_enemy_hp
    if @enemy.hp <= 0
      @enemy.hp = 0
      finish_battle()
    else
      enemy_attack()
    end
  end

  def game_over
    puts "#{@player.name} lose..."

    puts
    puts "==========================="
    puts "GAME OVER"

    gets
  end

  def check_player_hp
    if @player.hp <= 0
      @player.hp = 0
      game_over()
    else
      query_command()
    end
  end

  def enemy_attack
    damage_point = Dice[@enemy.attack_power]

    puts
    puts "==========================="
    puts "#{@enemy.name} attack."
    @player.hp -= damage_point
    puts "#{@player.name} damaged #{damage_point} point(s)."

    gets

    check_player_hp()
  end

  def player_attack
    damage_point = Dice[@player.attack_power]

    puts
    puts "==========================="
    puts "#{@player.name} attack"
    @enemy.hp -= damage_point
    puts "#{@enemy.name} damaged #{damage_point} point(s)."

    gets

    check_enemy_hp()
  end

  def player_hoimi
    cure_point = Dice[8]

    puts
    puts "==========================="
    puts "#{@player.name} call hoimi."
    @player.hp = [@player.hp + cure_point, @player.max_hp].min
    puts "#{@player.name} cured #{cure_point} point(s)"

    gets

    enemy_attack()
  end

  def query_command
    @turn_count += 1

    puts
    puts "==========================="
    puts "#{@player.name} HP: #{@player.hp}"
    puts " 1 Attack"
    puts " 2 Hoimi"
    puts "Command? [1]"

    command = gets.chomp

    case command
    when "Hoimi", "2"
      player_hoimi()
    else
      player_attack()
    end
  end

  def encounter
    @enemy = Dice.shuffle(@enemy_classes).new

    puts "==========================="
    puts "#{@player.name} encountered a #{@enemy.name}."

    gets

    query_command()
  end

  def start
    encounter()
  end
end

