require 'Shellwords'

module Stalkedbybean
  class Provision

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
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

  end
end
