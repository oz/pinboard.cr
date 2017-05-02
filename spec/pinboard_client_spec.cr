require "./spec_helper"

require "./support/fixtures"
require "./support/test_transport"

describe Pinboard::Client do
  transport = TestTransport.new
  client = Pinboard::Client.new("test-token")
  client.transport = transport

  describe "#last_update" do
    it "should return a Time" do
      dt = Time.new(2017, 4, 20, 10, 0, 5)
      transport.mock("/posts/update", Fixtures::UPDATE_TIME) do
        client.last_update.should eq(dt)
      end
    end
  end

  describe "#get" do
    it "should return post details when passed a single URL" do
      transport.mock("/posts/get", Fixtures::SINGLE_POST) do
        post = client.get("https://www.crystal-lang.org")
        post.should be_a Pinboard::Post
        post.time.should be_a Time
        post.shared.should be_true
        post.toread.should be_false
        post.tags.should eq(["programming", "languages", "crystal"])
      end
    end

    it "should return several posts when filtering with date and tags" do
      transport.mock("/posts/get", Fixtures::SEVERAL_POSTS) do
        posts = client.get(date: Time.now, tags: %w(foo bar))
        posts.should be_a Array(Pinboard::Post)
      end
    end
  end

  describe "#recent" do
    it "should return an Array of posts" do
      transport.mock("/posts/recent", Fixtures::EMPTY_POSTS) do
        client.recent.should be_a Array(Pinboard::Post)
      end
    end

    it "should filter posts by tag" do
      transport.mock("/posts/recent", Fixtures::EMPTY_POSTS) do
        client.recent(tags: %w(one two three)).should be_a Array(Pinboard::Post)
      end
    end

    it "should accept a limit for post count" do
      transport.mock("/posts/recent", Fixtures::EMPTY_POSTS) do
        client.recent(count: 42).should be_a Array(Pinboard::Post)
      end
    end
  end
end
