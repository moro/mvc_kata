# coding: utf-8


When /^`([^`]*)`を対話的に実行する$/ do |cmd|
  When %Q(I run \`#{cmd}\` interactively)
end

Then  /(?:標準)?出力に次のとおり表示されていること:/ do |expected|
  assert_partial_output(expected, all_output)
end
