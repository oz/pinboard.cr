require "http/params"
require "http/client"
require "time"

require "./base"
require "./query_params"
require "./http/params"
require "../error"

module Pinboard
  module Transport
    class HTTP < Base
      BASE_URL = "https://api.pinboard.in/v1"

      property :token

      def initialize(@token = ""); end

      def get(path : String)
        get path, {} of String => String
      end

      def get(path : String, params : Hash)
        url = build_url(path, params)
        res = ::HTTP::Client.get(url)
        raise Pinboard::ServerError.new(res.status_message) if res.status_code >= 500
        res.body
      end

      def build_url(path : String, raw_params : Hash) : String
        params = QueryParams.encode(raw_params)
        params["format"] = "json"
        params["auth_token"] = token
        query = ::HTTP::Params.encode(params)
        "#{BASE_URL}#{path}?#{query}"
      end
    end
  end
end
