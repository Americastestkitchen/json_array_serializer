# JSONArraySerializer

A class to serialize and deserialize arrays of JSON strings. This is useful when doing things like saving arrays of objects to a database or file, or sending them over the wire.

## Installation

Add this line to your application's Gemfile:

    gem 'json_array_serializer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_array_serializer

## Usage

You can use the `JSONArraySerizalizer` directly on a attribute of a Rails model as follows.

```ruby
class Foo < ActiveRecord::Base
  serialize :bar, JSONArraySerializer.new
end
```

Or if you want to save object with more complexity, and custom functionality, simply extend `JSONArraySerizalizer`.

```ruby
# A class to hold a collection of commands.
#
class CommandArray < JSONArraySerizalizer
  def perform
    each do |command|
      result = system(command.program)
      raise "Error" if !result && command.raise_exception
    end
  end
end
```

You can also pass in a class to load the individual JSON objects as when extending the base `JSONArraySerizalizer`.

```ruby
class Developer < OpenStruct
  def develop(name)
    # Write code.
  end
end

class Company < ActiveRecord::Base
  serialize :developers, JSONArraySerializer.new(Developer)
end
```

The class you pass to `JSONArraySerializer.new` __must__ have the following two methods.

```
# A.new : Hash -> A
# a.to_h : -> Hash (where a is an instance of A)
```
