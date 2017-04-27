require "spec"
require "json"

require "../src/pinboard"

class TestTransport < Pinboard::Transport::Base
  property :token
  def initialize(&block)
    @token = ""
    @responses = {} of String => String
    yield self
  end

  def configure(&block)
    yield self
  end

  def add(path : String, response : String)
    @responses[path] = response
  end

  def get(path : String)
    @responses[path]
  end

  def get(path : String, params : Hash(_, _))
    @responses[path]
  end
end
