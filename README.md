# dekoden
dekoden decorates methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "dekoden"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dekoden

## Usage

```ruby
require "dekoden"

module MyCollection
  class MyDecorator
    def initialize(suffix)
      @suffix = suffix
    end

    def call(*args, blk)
      yield(*args, blk) + @suffix
    end
  end
end

class MyClass
  extend Dekoden::Decoratable
  decorators MyCollection

  MyDecorator " World"
  def my_method(message)
    message
  end
end

MyClass.new.my_method("Hello")
# => "Hello World"

# Make all classes and modules decoratable
class Module
  include Dekoden::Decoratable
end

# Make decorators available to all classes and modules
class Module
  include Dekoden::Decoratable
  singleton_decorators MyCollection
end

# Instance methods (inherited)

class MyClass
  MyDecorator " World"
  def my_method(message)
    message
  end
end

# Class methods (inherited)

class MyClass
  MyDecorator " World"
  def self.my_method(message)
    message
  end
end

# Module methods (to be included)

module MyModule
  MyDecorator " World"
  def my_method(message)
    message
  end
end

# Module methods (to be called directly or extended)

class MyModule
  MyDecorator " World"
  def self.my_method(message)
    message
  end
end
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katsuya94/dekoden.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

