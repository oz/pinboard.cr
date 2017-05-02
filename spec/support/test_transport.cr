require "../../src/pinboard"

class TestTransport < Pinboard::Transport::Base
  property :token

  def initialize
    @token = ""
    @responses = {} of String => String
  end

  def mock(url, response, &block)
    add(url, response)
    yield
    rm(url)
  end

  def rm(url)
    @responses.delete url
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
