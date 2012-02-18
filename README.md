# ActiveESP

**NOTE**: ActiveESP is still a very early project with limited support.  Be careful when using it as implementations are still changing rapidly.  Feel free to contribute and help us with our first official release!

ActiveESP is an abstraction library for managing subscribers, campaigns, and other email marketing facilities. It aims to provide a consistent interface to interact with the numerous ESPs operating with different terminologies and strategies.

This framework provides some common classes for managing email marketing data structures as well as the adapters for interfacing with the providers' APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'active_esp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_esp

## Basic usage

For basic usage, an instance of any of the supported providers may be instantiated and used independently by calling methods on the provider directly.

```
subscriber = ActiveESP::Subscriber.new(
  :email => 'brian@xq3.net', 
  :name => 'Brian Morton'
)

provider = ActiveESP::Providers::MailChimp.new(
  :api_key => '12345678901234567890-us4'
)

list = ActiveESP::List.new(:id => '03b3b0f203')

provider.subscribe(subscriber, list) # => true
```

## Configuring and using a shared provider

For a better integration into an application, using a shared provider tries to hide as much of the provider's specific implementation details as it can.  After the provider is configured, as many calls as possible are genericized to work across all implementations.

```
ActiveESP.configure do |c|
  c.provider :mail_chimp
  c.credentials :api_key => '12345678901234567890-us4'
end

ActiveESP.provider # => #<ActiveESP::Providers::MailChimp:0x007f868b33fb30 @api_key="12345678901234567890-us4">
```

## Using convenience methods

Convenience methods are defined on the basic Subscriber and List classes for sending themselves in an API request to the shared provider.  After configuring a provider, these methods can be fired on any subscriber or list object.

```
ActiveESP.configure do |c|
  c.provider :mail_chimp
  c.credentials :api_key => '12345678901234567890-us4'
end

member = ActiveESP::Subscriber.new(
  :email => 'brian@xq3.net', 
  :name => 'Brian Morton'
)

list = ActiveESP::List.new(:id => '123456')

member.subscribe!(list)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
