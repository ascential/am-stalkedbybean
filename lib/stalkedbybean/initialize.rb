require 'Shellwords'
require 'yaml'

module Stalkedbybean
  class Initialize

    def self.parse_options(filepath, options)
      @options = self.load_default_options(filepath)
      @options.merge!(options)
    end

    def self.load_default_options(file_path)
      default_options = YAML::load(open(file_path))
      convert_options_to_symbols = default_options.map { |option, default_value| [option.to_sym, default_value] }
      Hash[convert_options_to_symbols]
    end

    def self.initialize_app
      system("eb init #{@options[:app_name]} --profile #{@options[:aws_profile]} -r #{@options[:aws_region]} -p #{@options[:platform_arn]}")
    end

  end
end
