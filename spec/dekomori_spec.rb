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

  class Foo
    include TestCollection

    Bar "bleep", "bloop"
    def baz
      "blop"
    end
  end

  it "wraps instance methods" do
    expect(Foo.new.baz).to eq(["bleep", "blop", "bloop"])
  end

end
