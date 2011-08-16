# coding: utf-8
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

