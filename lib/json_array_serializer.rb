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
      hash = JSON.load(e)
      (element_class == Hash) ? hash : element_class.new(hash)
    end
  end

  # [element_class] -> [JSON String]
  # Takes an array of element_classes and dumps them
  # into JSON Strings, and returns the array of them.
  #
  def dump(array)
    array.map do |e|
      hash = (element_class == Hash) ? e : e.to_h
      JSON.dump(hash)
    end
  end
end
