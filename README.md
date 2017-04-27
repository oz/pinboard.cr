# pinboard

A crystal client for [Pinboard] API.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pinboard:
    github: [your-github-name]/pinboard
```

## Usage

```crystal
require "pinboard"

pinboard = Pinboard::Client.new(token: "my secret token")
posts = pinboard.posts
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/pinboard/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Arnaud Berthomier - creator, maintainer

[Pinboard]: https://pinboard.in/
