# pinboard

[![Build Status](https://travis-ci.org/oz/pinboard.cr.svg?branch=master)](https://travis-ci.org/oz/pinboard.cr)

A crystal client for the [Pinboard] API.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pinboard:
    git: https://git.cypr.io/oz/pinboard.cr.git
```

## Usage

```crystal
require "pinboard"

pinboard = Pinboard::Client.new(token: "my secret token")
posts = pinboard.recent
if posts.is_a?(Pinboard::Error)
  puts posts.to_s
else
  posts.each do |post|
    puts "#{post.title}\n  url:#{post.url}\n  tags: #{post.tags.join(",")}\n"
  end
end
```

Pinboard returns either a `Pinboard::Error`, or something else. Check the tests
to be sure.

## Contributing

1. Clone `https://git.cypr.io/oz/pinboard.cr.git`,
2. Create your feature branch (`git checkout -b my-new-feature`),
3. Commit your changes (`git commit -am 'Add some feature'`),
4. Create a patch (`git format-patch origin`),
5. Send patch to `oz@cypr.io`.

## Contributors

- [oz](https://github.com/oz) Arnaud Berthomier - creator, maintainer

[Pinboard]: https://pinboard.in/
