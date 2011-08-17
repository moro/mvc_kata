# coding: utf-8

Before do
  @aruba_io_wait_seconds = 0.01
end

def type_command(command)
  type command
  2.times { type "\n" }
end

Given /^以下のコマンドを入力する:$/ do |table|
  @aruba_io_wait_seconds = 0.001
  type "\n"
  table.hashes.each {|row| type_command(row['コマンド']) }
  type "\n"
end

Given /ランダム値を以下のとおり固定する:/ do |table|
  v = table.hashes.first
  write_file 'stub_dice.rb', <<-RUBY
require 'dice'
module Dice
  def [](num) ; #{v['ダメージ']} ; end
  def roll(arr); MvcKata::#{v['敵']} ; end
end
RUBY
end

Given /^(英語モードで)?起動する$/ do |english|
  opt = !!english ? ' english' : ''
  Given  %Q{`ruby -I../../lib -r./stub_dice.rb ../../bin/mvc_kata#{opt}`を対話的に実行する}
end

