require 'spec_helper'
require 'mvc_kata/commands'
require 'mvc_kata/models'

module MvcKata
  describe Command do
    let(:player) { Player.new }
    let(:slime) { Slime.new }

    describe Command::Attack do
      let(:command) { Command::Attack.new(player, slime) }
      specify do
        player.should_receive(:attack).with(slime)
        command.execute
      end
    end

    describe Command::Cure do
      let(:command) { Command::Cure(20).new(player, slime) }
      specify do
        player.should_receive(:cure).with(20)
        command.execute
      end
    end
  end
end

