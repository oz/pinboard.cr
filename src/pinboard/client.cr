require "time"

require "./error"
require "./transport"
require "./post"
require "./post_list"
require "./date_list"

module Pinboard
  class Client
    property :transport

    def initialize(token, @transport : Transport::Base = Transport::HTTP.new)
      @transport.token = token
    end

    # Returns the most recent time a bookmark was added, updated or deleted.
    def last_update
      res = transport.get "/posts/update"
      json = JSON.parse res
      date_format = Time::Format.new("%FT%TZ", Time::Location.local)
      date_format.parse json["update_time"].to_s
    rescue e
      Error.new(cause: e)
    end

    # Add a bookmark, but don't replace if it already existed.
    def add(post : Post)
      post.replace = false
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    rescue e
      Error.new(cause: e)
    end

    # Add a bookmark, always replacing it.
    def add!(post)
      post.replace = true
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    rescue e
      Error.new(cause: e)
    end

    # Delete a bookmark by URL.
    def delete(url)
      res = transport.get "/posts/delete", {"url" => url}
      code = JSON.parse(res)["result_code"]
      code == "done"
    rescue e
      Error.new(cause: e)
    end

    # Get a single Post by URL.
    def get(url)
      res = transport.get "/posts/get", {"url" => url}
      posts = PostList.from_json(res).posts
      if posts.empty?
        nil
      else
        posts.first
      end
    rescue e
      Error.new(cause: e)
    end

    # Find posts by tag, or date.
    def get(date : Time? = nil, tags : Array(String)? = nil, meta = false)
      res = transport.get "/posts/get", {"dt" => date, "tag" => tags, "meta" => meta}
      PostList.from_json(res).posts
    rescue e
      Error.new(cause: e)
    end

    def dates(tags = nil)
      res = transport.get "/posts/dates", {"tag" => tags}
      Pinboard::DateList.from_json(res)
    rescue e
      Error.new(cause: e)
    end

    # Returns a list of the user's most recent posts, filtered by tag.
    def recent(tags = nil, count = 15)
      params = {"tag" => tags, "count" => count}
      res = transport.get "/posts/recent", params
      PostList.from_json(res).posts
    rescue e
      Error.new(cause: e)
    end

    def posts(tags = nil, page = 0, start_at = nil, end_at = nil)
      params = {
        "start"  => page,
        "tag"    => tags,
        "fromdt" => start_at,
        "todt"   => end_at,
      }
      res = transport.get "/posts/all", params
      Array(Pinboard::Post).from_json res
    rescue e
      Error.new(cause: e)
    end
  end
end
