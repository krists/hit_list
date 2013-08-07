if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require "fakeredis"
require 'timecop'
require 'hot_or_not'