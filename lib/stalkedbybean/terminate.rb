require 'Shellwords'

module Stalkedbybean
  class Terminate

    def self.parse_options(file_path, options)
      @options = self.load_default_options(file_path)
      @options.merge!(options)
    end

    def self.terminate_environment
      system(
       "eb terminate #{@options[:environment]} --all --profile #{@options[:aws_profile]} -r #{@options[:aws_region]}",
      )
    end

    private

    def self.load_default_options(file_path)
      default_options = YAML::load(open(file_path))
      convert_options_to_symbols = default_options.map { |option, default_value| [option.to_sym, default_value] }
      Hash[convert_options_to_symbols]
    end
    
  end
end
