# ActiveESP

ActiveESP is an abstraction library for managing subscribers, campaigns, and other email marketing facilities. It aims to provide a consistent interface to interact with the numerous ESPs operating with different terminologies and strategies.

This framework provides some common classes for managing email marketing data structures as well as the adapters for interfacing with the providers' APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'active_esp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_esp

## Usage

```
subscriber = ActiveESP::Subscriber.new(
  :email => 'brian@xq3.net', 
  :name => 'Brian Morton'
)

provider = ActiveESP::Provider::MailChimp.new(
  :api_key => '12345678901234567890-us4'
)

list = ActiveESP::List.new(:id => '03b3b0f203')

provider.subscribe(subscriber, list) # => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
