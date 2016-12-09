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

  # module TestCollection
  #   class Bar
  #     def initialize(pre, post)
  #       @pre = pre
  #       @post = post
  #     end
  #
  #     def call(*args, blk)
  #       [@pre, yield(*args, blk), @post]
  #     end
  #   end
  # end

  # before(:each) do
  #   stub_const("Foo", Class.new)
  #   class Foo
  #     extend Dekoden::Decoratable
  #     decorators TestCollection
  #   end
  #   stub_const("Baz", Module.new)
  #   module Baz
  #     extend Dekoden::Decoratable
  #     decorators TestCollection
  #   end
  #   stub_const("Qux", Class.new)
  #   class Qux
  #     include Baz
  #   end
  # end

  # it "wraps instance methods" do
  #   class Foo
  #     Bar "bleep", "bloop"
  #     def bap
  #       "blop"
  #     end
  #   end
  #   expect(Foo.new.bap).to eq(["bleep", "blop", "bloop"])
  # end
  #
  # it "allows wrapped instance methods to take arguments" do
  #   class Foo
  #     Bar "cat", "mouse"
  #     def bop(arg)
  #       arg
  #     end
  #   end
  #   expect(Foo.new.bop("dog")).to eq(["cat", "dog", "mouse"])
  # end
  #
  # it "allows instance method decorators to be nested" do
  #   class Foo
  #     Bar "north", "south"
  #     Bar "east", "west"
  #     def bip
  #       "cardinal"
  #     end
  #   end
  #   expect(Foo.new.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  # end
  #
  # it "wraps class methods" do
  #   class Foo
  #     Bar "meow", "woof"
  #     def self.boo
  #       "moo"
  #     end
  #   end
  #   expect(Foo.boo).to eq(["meow", "moo", "woof"])
  # end
  #
  # it "allows wrapped class methods to take arguments" do
  #   class Foo
  #     Bar "meow", "woof"
  #     def self.boz(arg)
  #       arg
  #     end
  #   end
  #   expect(Foo.boz("goo")).to eq(["meow", "goo", "woof"])
  # end
  #
  # it "allows class method decorators to be nested" do
  #   class Foo
  #     Bar "north", "south"
  #     Bar "east", "west"
  #     def self.bip
  #       "cardinal"
  #     end
  #   end
  #   expect(Foo.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  # end
  #
  # it "wraps module methods" do
  #   module Baz
  #     Bar "meow", "woof"
  #     def self.boo
  #       "moo"
  #     end
  #   end
  #   expect(Baz.boo).to eq(["meow", "moo", "woof"])
  # end
  #
  # it "allows wrapped module methods to take arguments" do
  #   module Baz
  #     Bar "meow", "woof"
  #     def self.boz(arg)
  #       arg
  #     end
  #   end
  #   expect(Baz.boz("goo")).to eq(["meow", "goo", "woof"])
  # end
  #
  # it "allows module method decorators to be nested" do
  #   module Baz
  #     Bar "north", "south"
  #     Bar "east", "west"
  #     def self.bip
  #       "cardinal"
  #     end
  #   end
  #   expect(Baz.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  # end
  #
  # it "wraps module instance methods" do
  #   module Baz
  #     Bar "meow", "woof"
  #     def boo
  #       "moo"
  #     end
  #   end
  #   expect(Qux.new.boo).to eq(["meow", "moo", "woof"])
  # end
  #
  # it "allows wrapped module instance methods to take arguments" do
  #   module Baz
  #     Bar "meow", "woof"
  #     def boz(arg)
  #       arg
  #     end
  #   end
  #   expect(Qux.new.boz("goo")).to eq(["meow", "goo", "woof"])
  # end
  #
  # it "allows module instance method decorators to be nested" do
  #   module Baz
  #     Bar "north", "south"
  #     Bar "east", "west"
  #     def bip
  #       "cardinal"
  #     end
  #   end
  #   expect(Qux.new.bip).to eq(["north", ["east", "cardinal", "west"], "south"])
  # end
end
