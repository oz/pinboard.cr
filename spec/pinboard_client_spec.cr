require "./spec_helper"

describe Pinboard::Client do
  client = Pinboard::Client.new("test-token")
  client.transport = TestTransport.new do |test|
    test.add("/posts/update", %({"update_time": "2017-04-20T10:00:05Z"}))
    test.add("/posts/get", %({
      "date":"2017-04-26T13:42:31Z",
      "user":"oz",
      "posts": [
        {
          "href":"https:\/\/www.crystal-lang.org\/",
          "description":"The Crystal Programming Language",
          "extended":"",
          "meta":"1234567890abcdef01234567890abcde",
          "hash":"1234567890abcdef01234567890abcde",
          "time":"2017-04-26T13:42:31Z",
          "shared":"yes",
          "toread":"no",
          "tags":"programming languages crystal"
        }
      ]
    }))
  end

  describe "#update" do
    it "should return a Time" do
      dt = Time.new(2017, 4, 20, 10, 0, 5)
      client.update.should eq(dt)
    end
  end

  describe "#get" do
    it "should return post details when passed a single URL" do
      post = client.get("https://www.crystal-lang.org")
      post.should be_a Pinboard::Post
      post.time.should be_a Time
      post.shared.should be_true
      post.toread.should be_false
      post.tags.should eq(["programming", "languages", "crystal"])
    end
  end
end
