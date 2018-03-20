require 'Shellwords'

module Stalkedbybean
  class Deploy

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
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

  end
end
