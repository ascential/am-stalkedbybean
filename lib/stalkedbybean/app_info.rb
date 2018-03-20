require 'Shellwords'

module Stalkedbybean
  class AppInfo

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
    end


    def self.list_application_versions
      system(
        "eb appversion --profile #{@options[:aws_profile]} -r #{@options[:aws_region]}"
      )
    end

  end
end
