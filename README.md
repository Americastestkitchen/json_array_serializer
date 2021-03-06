# JSONArraySerializer [![Build Status](https://travis-ci.org/Americastestkitchen/json_array_serializer.svg?branch=master)](https://travis-ci.org/Americastestkitchen/json_array_serializer)

A class to serialize and deserialize arrays of JSON strings. This is useful when doing things like saving arrays of objects to a database or file, or sending them over the wire. The main focus of this gem is aimed at Rails's `ActiveRecord::Base#serialize`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_array_serializer'
```

## Usage

You can use the `JSONArraySerizalizer` directly on a attribute of a Rails model as follows. This will save the `bar` attribute as a string of JSON in the database, where `bar` is an array of hashes.

```ruby
class Foo < ActiveRecord::Base
  serialize :bar, JSONArraySerializer.new
end
```

### Specifying Element Class

You can pass a class to specify the type of the arrays elements.

```ruby
class Developer < OpenStruct
  def develop(name)
    # Write code.
  end
end

class Company < ActiveRecord::Base
  serialize :developers, JSONArraySerializer.new(element_class: Developer)
end
```

The `element_class` you pass to `JSONArraySerializer.new` __must__ have the following two methods.

```
# A.new : Hash -> A
# a.to_h : -> Hash (where a is an instance of A)
```

### Specifying Array Class

You can pass a class to specify the type of the loaded array itself. This allows for serializing classes that act like arrays.

```ruby
class SongArray < Array
  def play_all
    each do |song|
      queue song['name']
    end
  end
end

class Playlist < ActiveRecord::Base
  serialize :songs, JSONArraySerializer.new(array_class: SongArray)
end
```

The `array_class` you pass to `JSONArraySerializer.new` __must__ have the following two methods.

```
# A.new : Array -> A
# a.to_a : -> Array (where a is an instance of A)
```

### Specifying the Database Type

This gem allows you to save arrays on either Text/String columns or Array columns. The default is `:text`.

```ruby
  serialize :foo, JSONArraySerializer.new                       # Will save to :text.
  serialize :foo, JSONArraySerializer.new(column_type: :text)   # Same as above.
  serialize :foo, JSONArraySerializer.new(column_type: :array)  # Saves to array column.
```

## Example

```ruby
class Developer < OpenStruct
  def develop(name)
    # Write code.
  end
end

class DeveloperArray < Array
  def develop
    each { |d| d.develop }
  end
end

class Company < ActiveRecord::Base
  serialize :developers, JSONArraySerializer.new(array_class: DeveloperArray, element_class: Developer)
end
```
