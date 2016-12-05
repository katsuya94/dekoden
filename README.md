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
MyCollection = Dekoden::Collection.new

class MyDecorator < MyCollection::Decorator
  def initialize(suffix)
    @suffix = suffix
  end

  def around(message)
    yield(message + @suffix)
  end
end

class MyClass
  include MyCollection

  MyDecorator " World"
  def my_method(message)
    message
  end
end

MyClass.new.my_method("Hello")
# => "Hello World"
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katsuya94/dekoden.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

