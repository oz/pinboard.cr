require "time"

require "./post"
require "./post_list"
require "./date_list"
require "./transport"

module Pinboard
  class Client
    property :transport

    def initialize(token : String, @transport : Transport::Base = Transport::HTTP.new)
      @transport.token = token
    end

    # Returns the most recent time a bookmark was added, updated or deleted.
    def last_update : Time
      res = transport.get "/posts/update"
      json = JSON.parse res
      Time::Format.new("%FT%TZ").parse json["update_time"].to_s
    end

    # Add a bookmark, but don't replace if it already existed.
    def add(post : Post) : Bool
      post.replace = false
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    # Add a bookmark, always replacing it.
    def add!(post : Post) : Bool
      post.replace = true
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    # Delete a bookmark by URL.
    def delete(url : String)
      res = transport.get "/posts/delete", {"url" => url}
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    # Get a single Post by URL.
    def get(url : String) : Post | Nil
      res = transport.get "/posts/get", {"url" => url}
      posts = PostList.from_json(res).posts
      if posts.empty?
        nil
      else
        posts.first
      end
    end

    # Find posts by tag, or date.
    def get(date : Time, tags : Array(String), meta : Bool = false) : Array(Post)
      res = transport.get "/posts/get", {"dt" => date, "tag" => tags, "meta" => meta}
      PostList.from_json(res).posts
    end

    def dates(tags : Array(String) = [] of String) : Pinboard::DateList
      params = {} of String => Array(String)
      params["tag"] = tags unless tags.empty?
      res = transport.get "/posts/dates", params
      Pinboard::DateList.from_json(res)
    end

    # Returns a list of the user's most recent posts (default: 15).
    def recent : Array(Post)
      res = transport.get "/posts/recent"
      PostList.from_json(res).posts
    end

    # Returns a list of the user's most recent posts, filtered by tag.
    def recent(tags : Array = [] of String, count : Int32 = 15) : Array(Post)
      params = {"count" => count} of String => (Int32 | Array(String))
      params["tag"] = tags unless tags.empty?
      res = transport.get "/posts/recent", params
      PostList.from_json(res).posts
    end

    def posts
      [] of Post
    end
  end
end
