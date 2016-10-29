require "spec_helper"

describe Dekomori do
  it "has a version number" do
    expect(Dekomori::VERSION).not_to be nil
  end

  TestCollection = Dekomori::Collection.new

  class Bar < TestCollection::Decorator
    def initialize(pre, post)
      @pre = pre
      @post = post
    end

    def around
      [@pre, yield, @post]
    end
  end

  before(:each) do
    stub_const("Foo", Class.new)
    class Foo
      include TestCollection
    end
    stub_const("Baz", Module.new)
    module Baz
      include TestCollection
    end
    stub_const("Qux", Class.new)
    class Qux
      include Baz
    end
  end

  it "wraps instance methods" do
    class Foo
      Bar "bleep", "bloop"
      def bap
        "blop"
      end
    end
    expect(Foo.new.bap).to eq(["bleep", "blop", "bloop"])
  end

  it "allows wrapped instance methods to take arguments" do
    class Foo
      Bar "cat", "mouse"
      def bop(arg)
        arg
      end
    end
    expect(Foo.new.bop("dog")).to eq(["cat", "dog", "mouse"])
  end

  it "allows instance method decorators to be nested" do
    class Foo
      Bar "north", "south"
      Bar "east", "west"
      def bip
        "cardinal"
      end
    end
    expect(Foo.new.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  end

  it "wraps class methods" do
    class Foo
      Bar "meow", "woof"
      def self.boo
        "moo"
      end
    end
    expect(Foo.boo).to eq(["meow", "moo", "woof"])
  end

  it "allows wrapped class methods to take arguments" do
    class Foo
      Bar "meow", "woof"
      def self.boz(arg)
        arg
      end
    end
    expect(Foo.boz("goo")).to eq(["meow", "goo", "woof"])
  end

  it "allows class method decorators to be nested" do
    class Foo
      Bar "north", "south"
      Bar "east", "west"
      def self.bip
        "cardinal"
      end
    end
    expect(Foo.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  end

  it "wraps module methods" do
    module Baz
      Bar "meow", "woof"
      def self.boo
        "moo"
      end
    end
    expect(Baz.boo).to eq(["meow", "moo", "woof"])
  end

  it "allows wrapped module methods to take arguments" do
    module Baz
      Bar "meow", "woof"
      def self.boz(arg)
        arg
      end
    end
    expect(Baz.boz("goo")).to eq(["meow", "goo", "woof"])
  end

  it "allows module method decorators to be nested" do
    module Baz
      Bar "north", "south"
      Bar "east", "west"
      def self.bip
        "cardinal"
      end
    end
    expect(Baz.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  end

  it "wraps module instance methods" do
    module Baz
      Bar "meow", "woof"
      def boo
        "moo"
      end
    end
    expect(Qux.new.boo).to eq(["meow", "moo", "woof"])
  end

  it "allows wrapped module instance methods to take arguments" do
    module Baz
      Bar "meow", "woof"
      def boz(arg)
        arg
      end
    end
    expect(Qux.new.boz("goo")).to eq(["meow", "goo", "woof"])
  end

  it "allows module instance method decorators to be nested" do
    module Baz
      Bar "north", "south"
      Bar "east", "west"
      def bip
        "cardinal"
      end
    end
    expect(Qux.new.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  end
end
