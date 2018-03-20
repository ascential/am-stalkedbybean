require 'Shellwords'
require 'aws-sdk-elasticbeanstalk'

module Stalkedbybean
  class EnvVars

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
    end

    def self.update_configuration_options

      @client = Aws::ElasticBeanstalk::Client.new(region: "#{@options[:aws_region]}", profile: "#{@options[:aws_profile]}")

      resp = @client.update_environment({
        application_name: "#{@options[:app_name]}",
        environment_name: "#{@options[:app_name]}-#{@options[:environment]}",
        platform_arn: "#{@options[:platform_arn]}",
        option_settings: [
          {
              namespace: "aws:ec2:vpc",
              option_name: "VPCId",
              value: "#{@options[:vpc_id]}"
          },
          {
              namespace: "aws:autoscaling:launchconfiguration",
              option_name: "SecurityGroups",
              value: "#{@options[:vpc_security_groups]}"
          },
          {
              namespace: "aws:autoscaling:asg",
              option_name: "MaxSize",
              value: "1"
          },
          {
              namespace: "aws:autoscaling:asg",
              option_name: "MinSize",
              value: "1"
          },
          {
              namespace: "aws:autoscaling:launchconfiguration",
              option_name: "InstanceType",
              value: "#{@options[:instance_size]}"
          },
          {
              namespace: "aws:ec2:vpc",
              option_name: "ELBSubnets",
              value: "#{@options[:vpc_elb_subnets]}"
          },
          {
              namespace: "aws:ec2:vpc",
              option_name: "Subnets",
              value: "#{@options[:vpc_ec2_subnets]}"
          },
          {
              namespace: "aws:autoscaling:launchconfiguration",
              option_name: "EC2KeyName",
              value: "#{@options[:key_name]}"
          },
        ],
      })

      puts "Environment update has started. This will take some time."
    end

    def self.update_environment_variables
      system(
       "eb setenv #{@options[:env_vars]} --profile #{@options[:aws_profile]} --region #{@options[:aws_region]}"
      )
    end

    def self.print_environment_variables
      system(
       "eb printenv #{@options[:app_name]}-#{@options[:environment]} --profile #{@options[:aws_profile]} -r #{@options[:aws_region]}"
      )
    end

  end
end
