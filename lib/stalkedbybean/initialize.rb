require 'Shellwords'
require 'yaml'

module Stalkedbybean
  class Initialize

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
    end

    def self.initialize_app
      system("eb init #{@options[:app_name]} --profile #{@options[:aws_profile]} -r #{@options[:aws_region]} -p #{@options[:platform_arn]}")
    end

  end
end
