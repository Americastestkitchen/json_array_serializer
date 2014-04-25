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
  def initialize(element_class = Hash)
    @element_class = element_class
  end

  # [JSON String] -> [element_class]
  # Takes an array of JSON strings and loads them
  # into an array of element_classes.
  #
  def load(array)
    array.map do |e|
      if element_class == Hash
        JSON.load(e)
      else
        element_class.new(JSON.load(e))
      end
    end
  end

  # [element_class] -> [JSON String]
  # Takes an array of element_classes and dumps them
  # into JSON Strings, and returns the array of them.
  #
  def dump(array)
    array.map do |e|
      if element_class == Hash
        JSON.dump(e)
      else
        JSON.dump(e.to_h)
      end
    end
  end
end
