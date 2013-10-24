require_relative '../../spec/coveralls_helper'
require 'rake'
require 'aruba'
require 'aruba/cucumber'
require 'aruba/in_process'
require 'aruba/jruby' if RUBY_PLATFORM == 'java'
require 'pacto/server'

Before do
  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 15
end

# Was only going to use for @needs_server, but its easier to leave it running
@server = Pacto::Server::Dummy.new 8000, '/hello', '{"message": "Hello World!"}'
@server.start

Around do | scenario, block |
  Bundler.with_clean_env do
    block.call
  end
end
