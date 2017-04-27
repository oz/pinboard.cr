require "../spec_helper"

describe Pinboard::Transport::HTTP do
  transport = Pinboard::Transport::HTTP.new token: "test"

  it "builds URL correctly" do
    params = {
      "foo" => "bar",
      "bool" => "false"
    }
    url = transport.build_url("/test", params)
    url.should eq("https://api.pinboard.in/v1/test?foo=bar&bool=false&format=json&auth_token=test")
  end
end
