# -*- coding: utf-8 -*-
require 'dice'

class Living
  attr :hp, true
  attr :max_hp, true
  attr :name, true
  attr :attack_power, true

  def attack(other)
    damage_point = Dice[attack_power]
    other.hp -= damage_point
  end
end

class Enemy < Living
  attr :exp, true
end

class Slime < Enemy
  def initialize
    self.name = "SLIME"
    self.max_hp = 10
    self.hp = self.max_hp
    self.attack_power = 4
    self.exp = 1
  end
end

class Dragon < Enemy
  def initialize
    self.name = "DRAGON"
    self.max_hp = 20
    self.hp = self.max_hp
    self.attack_power = 8
    self.exp = 3000
  end
end

class Player < Living
  def initialize
    self.name = "PLAYER"
    self.max_hp = 10
    self.hp = self.max_hp
    self.attack_power = 3
  end
end

class Battle
  def initialize
    @enemy_classes = [Slime, Dragon]
    @player = Player.new
    @turn_count = 0
    @view_context = ViewContext::Ja.new
  end

  def finish_battle
    puts "#{@enemy.name}をたおした"

    puts
    puts "==========================="
    puts "かかったターン数#{@turn_count}"
    puts "経験値#{@enemy.exp}かくとく"

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
    puts "#{@player.name}はたおれました"

    puts
    puts "==========================="
    puts "ゲームオーバー"

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

  module ViewContext
    def unindent(string)
      trim = string.lines.map {|l| l[/^ +/].size }.min
      string.lines.map {|l| l[trim, l.length] }.join
    end

    class Ja
      include ViewContext

      def attacked(attacker, victim, damage)
        puts unindent(<<-VIEW)
          ===========================
          #{attacker.name}のこうげき
          #{victim.name}に#{damage}のダメージ
        VIEW
      end
    end
  end

  def __attack__(attacker, victim)
    old = victim.hp
    attacker.attack(victim)
    dp = old - victim.hp
    @view_context.attacked(attacker, victim, dp)
  end

  def enemy_attack
    __attack__(@enemy, @player)

    gets
    check_player_hp()
  end

  def player_attack
    __attack__(@player, @enemy)

    gets
    check_enemy_hp()
  end

  def player_hoimi
    cure_point = Dice[8]

    puts
    puts "==========================="
    puts "#{@player.name}はホイミをとなえた"
    @player.hp = [@player.hp + cure_point, @player.max_hp].min
    puts "HPが#{cure_point}回復した"

    gets

    enemy_attack()
  end

  def query_command
    @turn_count += 1

    puts
    puts "==========================="
    puts "#{@player.name}のHP: #{@player.hp}"
    puts " 1 たたかう"
    puts " 2 ホイミ"
    puts "コマンド? [1]"

    command = gets.chomp

    case command
    when "ホイミ", "2"
      player_hoimi()
    else
      player_attack()
    end
  end

  def encounter
    @enemy = Dice.shuffle(@enemy_classes).new

    puts "==========================="
    puts "#{@enemy.name}があらわれた"

    gets

    query_command()
  end

  def start
    encounter()
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

