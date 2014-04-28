require 'json'
require 'json_array_serializer/version'

class JSONArraySerializer
  attr_accessor :element_class, :array_class

  # Class -> void (hook)
  # Sets up the new JSONArraySerializer with it's elements
  # class. The element_class is what will be used to represent
  # each element of the stored JSON.
  #
  # The option :array_class MUST implement two methods:
  #
  # A.new : Array -> A
  # a.to_a : -> Array (where a is an instance of A)
  #
  # The option :element_class MUST implement two methods:
  #
  # A.new : Hash -> A
  # a.to_h : -> Hash (where a is an instance of A)
  #
  # The option :column_type MUST be one of :string | :text | :array.
  #
  def initialize(array_class: Array, element_class: Hash, column_type: :text)
    @array_class   = array_class
    @element_class = element_class
    @column_type   = column_type
  end

  # [JSON String] || JSON String -> array_class<element_class>
  # Takes the data from the database, and loads them into an
  # instance of `array_class` with elements of `element_class`.
  #
  def load(data)
    return data if data.nil?

    array = case @column_type
    when :array
      data.map do |json|
        hash = JSON.load(json)
        (element_class == Hash) ? hash : element_class.new(hash)
      end
    when :string, :text
      JSON.load(data).map do |hash|
        (element_class == Hash) ? hash : element_class.new(hash)
      end
    end

    (array_class == Array) ? array : array_class.new(array)
  end

  # array_class<element_class> -> [JSON String] || JSON String
  # Takes an instance of `array_class` with `element_class` elements
  # and dumps them either a array of JSON or JSON itself for the database.
  #
  def dump(data)
    return data if data.nil?

    case @column_type
    when :array
      data.to_a.map { |e| JSON.dump(e.to_h) }
    when :string, :text
      JSON.dump(data.to_a.map { |e| e.to_h })
    end
  end
end
