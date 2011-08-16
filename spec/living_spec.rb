# coding: utf-8
require 'spec_helper'
require 'mvc_kata'

describe Living do
  freeze_dice(1)

  let(:player) { Player.new }
  let(:slime) { Slime.new }

  describe '#attack(other)' do
    subject { slime }
    before do
      player.attack(slime)
    end
    its(:hp) { should == slime.max_hp - 1 }
  end
end

