require 'Shellwords'
require 'yaml'

module Stalkedbybean
  class Initialize
    extend self

    def parse_options(file_path, options)
      file_path ||= get_default_file_path
      @options = load_default_options(file_path)
      parsed_options = symbolize_option_names(options)
      @options.merge!(parsed_options)
    end

    def initialize_app
      system("eb init #{@options[:app_name]} --profile #{@options[:aws_profile]} -r #{@options[:aws_region]} -p #{@options[:platform_arn]}")
    end

    private

    def load_default_options(file_path)
      default_options = YAML::load(open(file_path))
      convert_options_to_symbols = symbolize_option_names(default_options)
    end

    def symbolize_option_names(options)
      options.map { |key, value| [key.to_sym, value] }.to_h
    end

    def get_default_file_path
      settings = YAML::load_file("config/.settings.yml")
      settings["default"]
    end

  end
end
