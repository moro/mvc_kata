Bundler.setup :cucumber
require 'aruba/cucumber'

$: << File.expand_path('../../lib', File.dirname(__FILE__))
require 'mvc_kata'
