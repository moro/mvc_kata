# coding: utf-8
require 'mvc_kata/commands'
module MvcKata
  class Living
    attr :hp, true
    attr :max_hp, true
    attr :name, true
    attr :attack_power, true

    def initialize
      @observers = []
      init_parameter
    end

    def add_observer(observer)
      @observers << observer
    end

    def action(context, target)
      Command::Attack.new(self, target)
    end

    def attack(other)
      Dice[attack_power].tap do |damage_point|
        other.damaged(damage_point)
        notify(:attacked, [self, other, damage_point])
        notify(:dead, other.enemy?) unless other.living?
      end
    end

    def damaged(val)
      @hp = [hp - val, 0].max
    end

    def living?
      hp > 0
    end

    def enemy?
      true
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

    class << self
      def inherited(child)
        children << child
      end

      def encounter
        Dice.roll(children)
      end

      def children
        @children ||= []
      end
    end
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
    Hoimi = Command::Cure(8)

    def action(context, target)
      (context == :hoimi) ? Hoimi.new(self, self) : super
    end

    def cure(power)
      Dice[power].tap do |cure_point|
        self.hp = [self.hp + cure_point, self.max_hp].min
        notify(:player_hoimi, cure_point)
      end
    end

    def enemy?; false end

    private

    def init_parameter
      self.name = "PLAYER"
      self.max_hp = 10
      self.hp = self.max_hp
      self.attack_power = 3
    end
  end
end

