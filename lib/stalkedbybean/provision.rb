require 'Shellwords'

module Stalkedbybean
  class Provision

    def self.parse_options(file_path, options)
      file_path ||= self.get_default_file_path
      @options = self.load_default_options(file_path)
      parsed_options = self.symbolize_option_names(options)
      @options.merge!(parsed_options)
    end

    def self.create_environment
      puts "provisioning app #{@options[:app_name]} in AWS region #{@options[:aws_region]} for environment #{@options[:environment]}"

      system(
      <<~HEREDOC
        eb create #{@options[:app_name]}-#{@options[:environment]} \
          --profile #{@options[:aws_profile]} \
          --region #{@options[:aws_region]} \
          -p #{@options[:platform_arn]} \
          -i #{@options[:instance_size]} \
          -ip #{@options[:app_name]}-#{@options[:environment]}-beanstalk-EC2 \
          -sr aws-elasticbeanstalk-service-role \
          --tags project=#{@options[:app_name]},environment=#{@options[:environment]} \
          --scale #{@options[:instance_count]} \
          --elb-type classic \
          --vpc.id #{@options[:vpc_id]} \
          --vpc.elbpublic \
          --vpc.ec2subnets #{@options[:vpc_ec2_subnets].join(',')} \
          --vpc.elbsubnets #{@options[:vpc_elb_subnets].join(',')} \
          --vpc.securitygroups #{@options[:vpc_security_groups].join(',')} \
          --version #{@options[:version]} \
          --envvars #{@options[:env_vars]} \
          --keyname #{@options[:key_name]}
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
