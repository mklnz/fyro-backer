require 'fyro-backer'
require 'debugger'
require 'fakefs/spec_helpers'
require 'timecop'

include Fyro::Backer

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
