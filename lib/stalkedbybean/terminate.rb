require 'Shellwords'

module Stalkedbybean
  class Terminate

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
    end

    def self.terminate_environment
      system(
       "eb terminate #{@options[:environment]} --all --profile #{@options[:aws_profile]} -r #{@options[:aws_region]}",
      )
    end

  end
end
