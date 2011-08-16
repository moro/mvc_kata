# coding: utf-8
require 'spec_helper'
require 'mvc_kata'

describe Player do
  freeze_dice(2)
  let(:player) { Player.new }

  describe '#cure(power)' do
    subject { player }
    context '体力が減っている場合' do
      before do
        player.hp = 3
        @cure_point = player.cure(8)
      end
      its(:hp) { should == 5 }
      specify { @cure_point.should == 2 }
    end

    context '体力満タンの場合' do
      specify do
        expect { player.cure(8) }.not_to change(player, :hp)
      end
    end
  end
end
