require 'Shellwords'

module Stalkedbybean
  class Deploy
    def self.parse_options(file_path, options)
      @options = self.load_default_options(file_path)
      @options.merge!(options)
      @app_tag = "#{@options[:app_name]}-#{@options[:environment]}"
    end

    def self.deploy_version
      system(
      <<~HEREDOC
       eb deploy #{@options[:app_name]}-#{@options[:environment]} \
        --profile #{@options[:aws_profile]} \
        -r #{@options[:aws_region]} \
        --version #{@options[:version]}
      HEREDOC
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
