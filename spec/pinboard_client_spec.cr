require "./spec_helper"

require "./support/fixtures"
require "./support/test_transport"

describe Pinboard::Client do
  transport = TestTransport.new
  client = Pinboard::Client.new("test-token")
  client.transport = transport

  describe "#last_update" do
    it "should return a Time" do
      dt = Time.local(2017, 4, 20, 10, 0, 5)
      transport.mock("/posts/update", Fixtures::UPDATE_TIME) do
        client.last_update.should eq(dt)
      end
    end

    it "should return a Pinboard::Error on errors..." do
      transport.mock("/posts/update", "BAD JSON") do
        client.last_update.should be_a(Pinboard::Error)
      end
    end
  end

  describe "#get" do
    it "should be nil when post is not found" do
      transport.mock("/posts/get", Fixtures::EMPTY_POSTS) do
        post = client.get("https://no-such-bookmark.com")
        post.should be_nil
      end
    end

    it "should return post details when passed a single URL" do
      transport.mock("/posts/get", Fixtures::SINGLE_POST) do
        post = client.get("https://www.crystal-lang.org").as(Pinboard::Post)
        post.should be_a Pinboard::Post
        post.time.should be_a Time
        post.shared?.should be_true
        post.toread?.should be_false
        post.tags.should eq(["programming", "languages", "crystal"])
      end
    end

    it "should return several posts when filtering with date and tags" do
      transport.mock("/posts/get", Fixtures::SEVERAL_POSTS) do
        posts = client.get(date: Time.local, tags: %w(foo bar))
        posts.should be_a Array(Pinboard::Post)
        posts.as?(Array(Pinboard::Post)).try(&.first).should be_a Pinboard::Post

        posts = client.get(date: Time.local)
        posts.should be_a Array(Pinboard::Post)
        posts.as?(Array(Pinboard::Post)).try(&.first).should be_a Pinboard::Post

        posts = client.get(tags: %w(foo bar))
        posts.should be_a Array(Pinboard::Post)
        posts.as?(Array(Pinboard::Post)).try(&.first).should be_a Pinboard::Post

        posts = client.get
        posts.should be_a Array(Pinboard::Post)
        posts.as?(Array(Pinboard::Post)).try(&.first).should be_a Pinboard::Post
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

  describe "#delete" do
    it "should be true when URL is found" do
      transport.mock("/posts/delete", Fixtures::DONE) do
        client.delete("http://someurl.com").should be_true
      end
    end

    it "should be false when URL is not found" do
      transport.mock("/posts/delete", Fixtures::ITEM_NOT_FOUND) do
        client.delete("http://someurl.com").should be_false
      end
    end
  end

  describe "#add" do
    it "should be true when Bookmark is added" do
      transport.mock("/posts/add", Fixtures::DONE) do
        post = Pinboard::Post.new(url: "http://example.com",
          title: "Example site")
        client.add(post).should be_true
      end
    end

    it "should be false when Bookmark already exist" do
      transport.mock("/posts/add", Fixtures::ITEM_EXISTS) do
        post = Pinboard::Post.new(url: "http://example.com",
          title: "Example site")
        client.add(post).should be_false
      end
    end

    it "should be true with tags and other params" do
      transport.mock("/posts/add", Fixtures::DONE) do
        post = Pinboard::Post.new(url: "http://example.com",
          title: "Example site",
          description: "So much text...",
          shared: false,
          tags: %w(foo bar baz))
        client.add(post).should be_true
      end
    end
  end

  describe "#add!" do
    it "should be true even if bookmark exist" do
      transport.mock("/posts/add", Fixtures::DONE) do
        post = Pinboard::Post.new(url: "http://example.com",
          title: "Example site")
        client.add!(post).should be_true
        client.add!(post).should be_true
      end
    end
  end

  describe "#dates" do
    it "should be return a DateList" do
      transport.mock("/posts/dates", Fixtures::DATE_LIST) do
        list = client.dates(%w(crystal))
        list.should be_a Pinboard::DateList
        list.as(Pinboard::DateList).dates.size.should eq 3
      end
    end
  end

  describe "#posts" do
    it "should return an Array of posts" do
      transport.mock("/posts/all", Fixtures::ALL_POSTS) do
        client.posts.should be_a Array(Pinboard::Post)
      end
    end

    it "should filter posts by tag" do
      transport.mock("/posts/all", Fixtures::ALL_POSTS) do
        client.posts(tags: %w(one two three)).should be_a Array(Pinboard::Post)
      end
    end

    it "should accept a page to paginate results" do
      transport.mock("/posts/all", Fixtures::ALL_POSTS) do
        posts = client.posts page: 42
        posts.should be_a Array(Pinboard::Post)
        posts.as(Array(Pinboard::Post)).first.url.should eq("https://usehelix.com/")
      end
    end

    it "should accept dates to limit results in time" do
      transport.mock("/posts/all", Fixtures::ALL_POSTS) do
        start_at = Time.local
        end_at = Time.utc(2050, 1, 1, 10, 10, 10)
        client.posts(page: 42, start_at: start_at).should be_a Array(Pinboard::Post)
        client.posts(page: 42, start_at: start_at, end_at: start_at).should be_a Array(Pinboard::Post)
      end
    end
  end
end
