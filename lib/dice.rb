
module Dice
  def [](num)
    rand(num) + 1
  end

  def shuffle(arr)
    arr.sample
  end

  extend self
end
