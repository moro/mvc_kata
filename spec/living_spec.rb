# coding: utf-8
require 'spec_helper'
require 'mvc_kata'

module MvcKata
describe Living do
  freeze_dice(3)

  let(:player) { Player.new }
  let(:slime) { Slime.new }

  describe '#attack(other)' do
    subject { slime }
    before do
      @damage = player.attack(slime)
    end
    its(:hp) { should == slime.max_hp - 3 }
    specify { @damage.should == 3 }
  end

  describe '#attack(other) w/observer' do
    let(:observer) { observer = double('observer') }
    let(:player) { Player.new([observer]) }

    before do
      observer.should_receive(:update).with(:attacked, player, slime, 3) { true }
    end

    specify { player.attack(slime) }
  end

  describe '#living?' do
    subject { slime }
    before do
      slime.hp = 0
    end
    it { should_not be_living }
  end
end
end

