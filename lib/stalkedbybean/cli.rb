require 'thor'
require 'stalkedbybean'
require 'stalkedbybean/generators/init'

module Stalkedbybean
  class CLI < Thor

    desc "CREATE", "Creates a new AWS application"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :platform_arn, :type => :string
    def create
      Stalkedbybean::Initialize.parse_options(options[:file_path], options)
      Stalkedbybean::Initialize.initialize_app
    end


    desc "init", "Generates a config file"
    def init(name)
      Stalkedbybean::Generators::Init.start([name])
    end

  end
end
