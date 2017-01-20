require "spec_helper"

describe Dekoden do
  before(:each) do
    stub_const("TestModule", Module.new)
  end

  it "decorates instance methods" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      class Foo
        extend Dekoden::Decoratable
        decorators TestCollection

        Bar()
        def baz
          3
        end
      end
    end
    expect(TestModule::Foo.new.baz).to eq(8)
  end

  it "decorates instance methods in a subclass" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      class Qux
        extend Dekoden::Decoratable
        decorators TestCollection
      end

      class Foo < Qux
        Bar()
        def baz
          3
        end
      end
    end
    expect(TestModule::Foo.new.baz).to eq(8)
  end

  it "decorates class methods" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      class Foo
        extend Dekoden::Decoratable
        decorators TestCollection

        Bar()
        def self.baz
          3
        end
      end
    end
    expect(TestModule::Foo.baz).to eq(8)
  end

  it "decorates class methods in a subclass" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      class Qux
        extend Dekoden::Decoratable
        decorators TestCollection
      end

      class Foo < Qux
        Bar()
        def self.baz
          3
        end
      end
    end
    expect(TestModule::Foo.baz).to eq(8)
  end

  it "decorates module methods" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      module Foo
        extend Dekoden::Decoratable
        decorators TestCollection

        Bar()
        def self.baz
          3
        end
      end
    end
    expect(TestModule::Foo.baz).to eq(8)
  end

  it "decorates methods included from a module" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      module Qux
        extend Dekoden::Decoratable
        decorators TestCollection

        Bar()
        def baz
          3
        end
      end

      class Foo
        include Qux
      end
    end
    expect(TestModule::Foo.new.baz).to eq(8)
  end

  it "decorates methods extended from a module" do
    module TestModule
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      module Qux
        extend Dekoden::Decoratable
        decorators TestCollection

        Bar()
        def baz
          3
        end
      end

      class Foo
        extend Qux
      end

    end
    expect(TestModule::Foo.baz).to eq(8)
  end

  context "when Module includes Decoratable" do
    before(:all) do
      Module.include(Dekoden::Decoratable)
    end

    it "decorates instance methods" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        class Foo
          decorators TestCollection

          Bar()
          def baz
            3
          end
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates instance methods in a subclass" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        class Qux
          decorators TestCollection
        end

        class Foo < Qux
          Bar()
          def baz
            3
          end
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates class methods" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        class Foo
          decorators TestCollection

          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates class methods in a subclass" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        class Qux
          decorators TestCollection
        end

        class Foo < Qux
          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates module methods" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        module Foo
          decorators TestCollection

          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates methods included from a module" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        module Qux
          decorators TestCollection

          Bar()
          def baz
            3
          end
        end

        class Foo
          include Qux
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates methods extended from a module" do
      module TestModule
        module TestCollection
          class Bar
            def call(*args, blk)
              5 + yield(*args, blk)
            end
          end
        end

        module Qux
          decorators TestCollection

          Bar()
          def baz
            3
          end
        end

        class Foo
          extend Qux
        end

      end
      expect(TestModule::Foo.baz).to eq(8)
    end
  end

  context "when Module includes Decoratable and Object includes decorators" do
    before(:all) do
      module TestCollection
        class Bar
          def call(*args, blk)
            5 + yield(*args, blk)
          end
        end
      end

      class Module
        include Dekoden::Decoratable
        singleton_decorators TestCollection
      end
    end

    it "decorates instance methods" do
      module TestModule
        class Foo
          Bar()
          def baz
            3
          end
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates instance methods in a subclass" do
      module TestModule
        class Qux
        end

        class Foo < Qux
          Bar()
          def baz
            3
          end
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates class methods" do
      module TestModule
        class Foo
          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates class methods in a subclass" do
      module TestModule
        class Qux
        end

        class Foo < Qux
          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates module methods" do
      module TestModule
        module Foo
          Bar()
          def self.baz
            3
          end
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end

    it "decorates methods included from a module" do
      module TestModule
        module Qux
          Bar()
          def baz
            3
          end
        end

        class Foo
          include Qux
        end
      end
      expect(TestModule::Foo.new.baz).to eq(8)
    end

    it "decorates methods extended from a module" do
      module TestModule
        module Qux
          Bar()
          def baz
            3
          end
        end

        class Foo
          extend Qux
        end
      end
      expect(TestModule::Foo.baz).to eq(8)
    end
  end

  describe "uses" do
    it "wraps instance methods" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "bleep", "bloop"
          def baz
            "blop"
          end
        end
      end

      expect(TestModule::Foo.new.baz).to eq(["bleep", "blop", "bloop"])
    end

    it "allows wrapped instance methods to take arguments" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "cat", "mouse"
          def baz(arg)
            arg
          end
        end
      end

      expect(TestModule::Foo.new.baz("dog")).to eq(["cat", "dog", "mouse"])
    end

    it "allows instance method decorators to be nested" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "north", "south"
          Bar "east", "west"
          def baz
            "cardinal"
          end
        end
      end

      expect(TestModule::Foo.new.baz).to eq(["north", ["east", "cardinal", "west"], "south"])
    end

    it "wraps class methods" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def self.baz
            "moo"
          end
        end
      end

      expect(TestModule::Foo.baz).to eq(["meow", "moo", "woof"])
    end

    it "wraps class methods when defined outside the class" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection
        end

        Foo.Bar "meow", "woof"
        def Foo.baz
          "moo"
        end
      end

      expect(TestModule::Foo.baz).to eq(["meow", "moo", "woof"])
    end

    it "allows wrapped class methods to take arguments" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def self.baz(arg)
            arg
          end
        end
      end

      expect(TestModule::Foo.baz("goo")).to eq(["meow", "goo", "woof"])
    end

    it "allows class method decorators to be nested" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        class Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "north", "south"
          Bar "east", "west"
          def self.baz
            "cardinal"
          end
        end
      end

      expect(TestModule::Foo.baz).to eq(["north", ["east", "cardinal", "west"], "south"])
    end

    it "wraps module methods" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def self.baz
            "moo"
          end
        end
      end

      expect(TestModule::Foo.baz).to eq(["meow", "moo", "woof"])
    end

    it "allows wrapped module methods to take arguments" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def self.baz(arg)
            arg
          end
        end
      end

      expect(TestModule::Foo.baz("goo")).to eq(["meow", "goo", "woof"])
    end

    it "allows module method decorators to be nested" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "north", "south"
          Bar "east", "west"
          def self.baz
            "cardinal"
          end
        end
      end

      expect(TestModule::Foo.baz).to eq(["north", ["east", "cardinal", "west"], "south"])
    end

    it "wraps module instance methods" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def baz
            "moo"
          end
        end

        class Qux
          include Foo
        end
      end

      expect(TestModule::Qux.new.baz).to eq(["meow", "moo", "woof"])
    end

    it "allows wrapped module instance methods to take arguments" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "meow", "woof"
          def baz(arg)
            arg
          end
        end

        class Qux
          include Foo
        end
      end

      expect(TestModule::Qux.new.baz("goo")).to eq(["meow", "goo", "woof"])
    end

    it "allows module instance method decorators to be nested" do
      module TestModule
        module TestCollection
          class Bar
            def initialize(pre, post)
              @pre = pre
              @post = post
            end

            def call(*args, blk)
              [@pre, yield(*args, blk), @post]
            end
          end
        end

        module Foo
          extend Dekoden::Decoratable
          decorators TestCollection

          Bar "north", "south"
          Bar "east", "west"
          def baz
            "cardinal"
          end
        end

        class Qux
          include Foo
        end
      end

      expect(TestModule::Qux.new.baz).to eq(["north", ["east", "cardinal", "west"], "south"])
    end
  end
end
