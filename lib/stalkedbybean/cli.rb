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

    desc "secrets [action]", "Sets up secrets using credstash"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    def secrets(action, *args)
      if action == "setup"
        Stalkedbybean::SecretsSetup.parse_options(options[:file_path], options)
        Stalkedbybean::SecretsSetup.create_key
        Stalkedbybean::SecretsSetup.create_credstash_table
      elsif action == "add"
        Stalkedbybean::SecretsSetup.parse_options(options[:file_path], options)
        Stalkedbybean::SecretsSetup.add_secret(args[0], args[1])
      elsif action == "get"
        Stalkedbybean::SecretsSetup.parse_options(options[:file_path], options)
        Stalkedbybean::SecretsSetup.get_secret(args[0])
      else
        puts (
          <<~HEREDOC
          USAGE: beanie secrets <command> [OPTIONS]
          COMMANDS:
            - setup
            - add KEY VALUE
            - get KEY
        HEREDOC
      )
      end
    end

    desc "setup_roles [OPTIONS]", "Sets up roles in AWS IAM"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    method_option :aws_account_id, :type => :string
    method_option :kms_arn, :type => :string
    def setup_roles
      Stalkedbybean::RoleSetup.parse_options(options[:file_path], options)
      Stalkedbybean::RoleSetup.setup_IAM
    end

    desc "init", "Generates a config file"
    def init(name)
      Stalkedbybean::Generators::Init.start([name])
    end

  end
end
