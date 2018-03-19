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
    method_option :platform_arn, :type => :string, :aliases => "-a"
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

    desc "provision [OPTIONS]", "Provisions new environment in AWS EB"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    method_option :platform_arn, :type => :string, :aliases => "-a"
    method_option :instance_size, :type => :string, :aliases => "-i"
    method_option :instance_count, :type => :string, :aliases => "-s"
    method_option :vpc_id, :type => :string
    method_option :vpc_ec2_subnets, :type => :array
    method_option :vpc_elb_subnets, :type => :array
    method_option :vpc_security_groups, :type => :array
    method_option :version, :type => :string, :aliases => "-v"
    method_option :key_name, :type => :string
    method_option :env_vars, :type => :string
    def provision
      Stalkedbybean::Provision.parse_options(options[:file_path], options)
      Stalkedbybean::Provision.create_environment
    end

    desc "deploy [OPTIONS]", "Deploys new version"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    method_option :version, :type => :string, :aliases => "-v"
    def deploy
      Stalkedbybean::Deploy.parse_options(options[:file_path], options)
      Stalkedbybean::Deploy.deploy_version
    end

    desc "terminate [OPTIONS]", "Terminates environment"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    def terminate
      Stalkedbybean::Terminate.parse_options(options[:file_path], options)
      Stalkedbybean::Terminate.terminate_environment
    end

    desc "update_config [OPTIONS]", "Updates new config"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    method_option :instance_size, :type => :string, :aliases => "-i"
    method_option :instance_count, :type => :string, :aliases => "-s"
    method_option :vpc_id, :type => :string
    method_option :vpc_ec2_subnets, :type => :array
    method_option :vpc_elb_subnets, :type => :array
    method_option :vpc_security_groups, :type => :array
    method_option :key_name, :type => :string
    method_option :env_vars, :type => :string
    def update_config
      Stalkedbybean::EnvVars.parse_options(options[:file_path], options)
      Stalkedbybean::EnvVars.update_configuration_options
    end

    desc "update_env_vars [OPTIONS]", "Updates environment variables"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :env_vars, :type => :string
    def update_env_vars
      Stalkedbybean::EnvVars.parse_options(options[:file_path], options)
      Stalkedbybean::EnvVars.update_environment_variables
    end

    desc "print_env_vars [OPTIONS]", "Prints existing environment variables"
    method_option :file_path, :type => :string, :aliases => "-f"
    method_option :app_name, :type => :string, :aliases => "-n"
    method_option :aws_profile, :type => :string, :aliases => "-p"
    method_option :aws_region, :type => :string, :aliases => "-r"
    method_option :environment, :type => :string, :aliases => "-e"
    def print_env_vars
      Stalkedbybean::EnvVars.parse_options(options[:file_path], options)
      Stalkedbybean::EnvVars.print_environment_variables
    end

    desc "init", "Generates a config file"
    def init(name)
      Stalkedbybean::Generators::Init.start([name])
    end

  end
end
