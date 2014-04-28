require 'rspec'
require 'ostruct'
require 'json_array_serializer'

# Connivance extensions.
require_relative '../ext/hash'
require_relative '../ext/open_struct'

RSpec.configure do |config|
  config.color_enabled = true
end