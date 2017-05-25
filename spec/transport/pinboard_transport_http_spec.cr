require "../spec_helper"

describe Pinboard::Transport::HTTP do
  transport = Pinboard::Transport::HTTP.new token: "test"

  describe "#build_url" do
    it "converts a Hash param to a query URL" do
      params = {
        "foo" => "bar",
        "bool" => false,
        "array" => %w(foo bar baz)
      }
      url = transport.build_url("/test", params)
      url.should eq("https://api.pinboard.in/v1/test?foo=bar&bool=no&array=foo%2Cbar%2Cbaz&format=json&auth_token=test")
    end
  end
end
