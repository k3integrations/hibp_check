# HibpCheck

This ruby gem is used to check passwords against a list of previously
compromised passwords that others have used.  It is intended to be extremely
light-weight, not depending on anything except Ruby's core libraries.

For more information about the api, see:
[https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/](https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/)



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hibp_check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hibp_check


## Usage

Using this is real easy.  Here's an example:

```ruby
# Call directly with a raw password
HibpCheck.new.password_used 'sekrit1'
# Returns: 33

# Call with a sha1 hash (for 'HelloWorld1')
HibpCheck.new.sha1_used '1924db611f8ae26075212fc9a0d2802e2bf17d3b'
# Returns: 46

HibpCheck.new.password_used 'something.never.seen.before.123.abc.xyz.def.ghi'
# Returns: 0
```

Those methods will return one of:
  * An integer, showing how many times that password has been compromised
  * Zero, if not found to have been compromised
  * nil or an error raised: if some problem occurred

You can pass a hash of Net::HTTP options when initializing the object that will
be used in the http get request.  For example:

```ruby
# Call with timeouts
hc = HibpCheck.new(open_timeout: 1, read_timeout: 1, ssl_timeout: 1)
hc.password_used 'sekrit1'
# Be prepared to rescue timeout errors
```

You can also inspect the request, response and results of the API request with
the following variables which are set on the object:
  * `params` - The hash of params given when the object was initialized
  * `prefix` - the first 5 characters of the SHA1 hash
  * `remainder` - the remaining characters of the SHA1 hash
  * `request` - the Net::HTTP::Get request that was sent
  * `response` - the response, usually Net::HTTPOK
  * `hashes` - the response of remainder hashes from the API, with counts


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

To run tests, try this:

```ruby
# After cloning the repo
./bin/setup

rspec spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/k3integrations/hibp_check. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HibpCheck project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/k3integrations/hibp_check/blob/master/CODE_OF_CONDUCT.md).
