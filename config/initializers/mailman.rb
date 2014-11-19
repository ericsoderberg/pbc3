require 'mailman'

class Configuration
  class << self
    attr_accessor :mailman_dir # version 2
    attr_accessor :mailman     # version 3
  end
end
