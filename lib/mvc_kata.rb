# -*- coding: utf-8 -*-
require 'dice'
require 'forwardable'

class Living
  attr :hp, false
  attr :max_hp, true
  attr :name, true
  attr :attack_power, true

  def initialize(observers = [])
    @observers = observers
    init_parameter
  end

  def attack(other)
    old_hp = other.hp
    damage_point = Dice[attack_power]
    other.hp -= damage_point
    (old_hp - other.hp).tap do |damage|
      notify(:attacked, [self, other, damage])
    end
  end

  def hp=(val)
    @hp = [val, 0].max
  end

  def living?
    hp > 0
  end

  private

  def init_parameter
  end

  def notify(method, args)
    @observers.each { |observer| observer.update(method, *args) }
  end
end

class Enemy < Living
  attr :exp, true
end

class Slime < Enemy
  private

  def init_parameter
    self.name = "SLIME"
    self.max_hp = 10
    self.hp = self.max_hp
    self.attack_power = 4
    self.exp = 1
  end
end

class Dragon < Enemy

  private

  def init_parameter
    self.name = "DRAGON"
    self.max_hp = 20
    self.hp = self.max_hp
    self.attack_power = 8
    self.exp = 3000
  end
end

class Player < Living
  def cure(power)
    Dice[power].tap do |cure_point|
      self.hp = [self.hp + cure_point, self.max_hp].min
    end
  end

  private

  def init_parameter
    self.name = "PLAYER"
    self.max_hp = 10
    self.hp = self.max_hp
    self.attack_power = 3
  end
end

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


class Battle
  attr_reader :player, :enemy, :turn_count
  def initialize
    @view_context = ViewContext::Ja.new(self)
    @enemy_classes = [Slime, Dragon]
    @player = Player.new([@view_context])
    @turn_count = 0
  end

  def mainloop
    while (@player.living? && @enemy.living?) do
      @turn_count += 1

      @view_context.query_command

      case command = wait
      when "ホイミ", "2"
        @view_context.player_hoimi(player.cure(8))
      else
        @player.attack(@enemy)
      end
      wait

      if enemy.living?
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

