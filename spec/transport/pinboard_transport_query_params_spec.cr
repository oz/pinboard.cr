require "../spec_helper"

describe Pinboard::Transport::QueryParams do
  enc = Pinboard::Transport::QueryParams

  describe "QueryParams.encode" do
    it "should transform Array(String) to a comma separated String" do
      h = {"value" => %w(foo bar baz)}
      enc.encode(h).should eq({"value" => "foo,bar,baz"})
    end

    it "should transform Bools to yes or no" do
      h = {"true" => true, "false" => false}
      enc.encode(h).should eq({"true" => "yes", "false" => "no"})
    end

    it "should transform Ints to String" do
      h = {"int" => 123}
      enc.encode(h).should eq({"int" => "123"})
    end

    it "should remove nil values" do
      h = {"foo" => "value", "nil" => nil}
      enc.encode(h).should eq({"foo" => "value"})
    end
  end
end
