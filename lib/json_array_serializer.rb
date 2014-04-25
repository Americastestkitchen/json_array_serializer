require 'json'
require 'json_array_serializer/version'

class JSONArraySerializer
  attr_accessor :element_class

  # Class -> void (hook)
  # Sets up the new JSONArraySerializer with it's elements
  # class. The element_class is what will be used to represent
  # each element of the stored JSON.
  #
  # The element class MUST implement two methods:
  #
  # A.new : Hash -> A
  # a.to_h : -> Hash (where a is an instance of A)
  #
  def initialize(element_class = Hash, column_type = :text)
    @element_class = element_class
    @column_type   = column_type
  end

  # [JSON String] -> [element_class]
  # Takes an array of JSON strings and loads them
  # into an array of element_classes.
  #
  def load(data)
    array = case @column_type
    when :array
      data
    when :string, :text
      JSON.load(data)
    end

    array.map do |json|
      hash = JSON.load(json)
      (element_class == Hash) ? hash : element_class.new(hash)
    end
  end

  # [element_class] -> [JSON String]
  # Takes an array of element_classes and dumps them
  # into JSON Strings, and returns the array of them.
  #
  def dump(array)
    serialized_array = array.map do |e|
      hash = (element_class == Hash) ? e : e.to_h
      JSON.dump(hash)
    end

    case @column_type
    when :array
      serialized_array
    when :string, :text
      JSON.dump(serialized_array)
    end
  end
end
