require "httparty"
require "json"
require "cgi"

require "active_support/core_ext"
require "active_support/inflector"
require "active_esp/version"
require "active_esp/rfc822"
require "active_esp/subscriber"
require "active_esp/list"
require "active_esp/provider/base"
require "active_esp/provider/mail_chimp"

# ActiveESP is an abstraction library for managing subscribers, campaigns, and other email
# marketing facilities. It aims to provide a consistent interface to interact with the
# numerous ESPs operating with different terminologies and strategies.
#
# This framework provides some common classes for managing email marketing data structures
# as well as the adapters for interfacing with the providers' APIs.
module ActiveESP
  # Your code goes here...
end
