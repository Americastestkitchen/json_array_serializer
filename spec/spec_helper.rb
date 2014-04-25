require 'rspec'
require 'ostruct'
require 'json_array_serializer'

class Hash
  def stringify
    inject({}) do |acc, (key, value)|
      acc[key.to_s] = case value
      when Symbol
        value.to_s
      when Hash
        value.stringify
      else
        value
      end
      acc
    end
  end
end

class OpenStruct
  def stringify_values
    OpenStruct.new(marshal_dump.stringify)
  end
end

RSpec.configure do |config|
  config.color_enabled = true
end