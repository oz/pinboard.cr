require "json"

module Pinboard
  struct DateList
    JSON.mapping({
      user:  String,
      tag:   String,
      dates: Hash(String, String)
    })
  end
end
