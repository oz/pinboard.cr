require "json"
require "time"

module Pinboard
  TIME_CONVERTER = Time::Format.new("%FT%TZ")

  module YesNoConverter
    def self.from_json(value : JSON::PullParser) : Bool
      value.read_string == "yes"
    end
  end

  module TagConverter
    def self.from_json(value : JSON::PullParser) : Array(String)
      value.read_string.split(" ")
    end
  end

  struct PostResponse
    JSON.mapping({
      date: { type: Time, converter: TIME_CONVERTER },
      user: String,
      posts: Array(Post)
    })
  end

  struct Post
    JSON.mapping({
      href:        String,
      description: String,
      extended:    String,
      meta:        String,
      hash:        String,
      time:        {type: Time, converter: TIME_CONVERTER},
      shared:      {type: Bool, converter: YesNoConverter},
      toread:      {type: Bool, converter: YesNoConverter},
      tags:        {type: Array(String), converter: TagConverter},
    })
  end
end
