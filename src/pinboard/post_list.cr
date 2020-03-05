require "json"
require "./post"

module Pinboard
  struct PostList
    JSON.mapping({
      date:  {type: Time, converter: TIME_CONVERTER},
      user:  String,
      posts: Array(Pinboard::Post),
    })
  end
end
