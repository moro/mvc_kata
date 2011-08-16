$: << File.expand_path('../lib', File.dirname(__FILE__))
require 'dice'

module FrozenDice
  def freeze_dice(val)
    before do
      Dice.stub!(:[]) {|ignroe| val }
    end
  end
end

RSpec.configure do |config|
  config.extend FrozenDice
end
