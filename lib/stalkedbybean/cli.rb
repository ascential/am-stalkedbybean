require 'thor'
require 'stalkedbybean'
require 'stalkedbybean/generators/init'

module Stalkedbybean
  class CLI < Thor

    desc "init", "Generates a config file"
    def init(name)
      Stalkedbybean::Generators::Init.start([name])
    end

  end
end
