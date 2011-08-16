
module Dice
  def [](num)
    rand(num) + 1
  end

  def roll(arr)
    arr.sample
  end

  extend self
end
