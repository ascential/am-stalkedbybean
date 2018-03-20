require 'Shellwords'

module Stalkedbybean
  class Deploy
    def self.parse_options(file_path, options)
      file_path ||= self.get_default_file_path
      @options = self.load_default_options(file_path)
      parsed_options = self.symbolize_option_names(options)
      @options.merge!(parsed_options)
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
      convert_options_to_symbols = symbolize_option_names(default_options)
    end

    def self.symbolize_option_names(options)
      options.map { |key, value| [key.to_sym, value] }.to_h
    end

    def self.get_default_file_path
      settings = YAML::load_file("config/.settings.yml")
      settings["default"]
    end

  end
end
