require 'aws-sdk-iam'

module Stalkedbybean
  class RoleSetup

    def self.parse_options(file_path, options)
      @options = Stalkedbybean::Parser.parse_options(file_path, options)
    end

    def self.setup_IAM
      
      @app_tag = "#{@options[:app_name]}-#{@options[:environment]}"
      @client = Aws::IAM::Client.new(region: "#{@options[:aws_region]}", profile: "#{@options[:aws_profile]}")
      @iam = Aws::IAM::Resource.new(client: @client)

      role_name = "#{@app_tag}-beanstalk-EC2"

      begin
        role = self.create_role
        puts "Role created"
      rescue Aws::IAM::Errors::EntityAlreadyExists
        puts "Role already created"
        role = @client.get_role({
             role_name: role_name
          })
      end

      begin
        cred_stash_policy = self.create_cred_stash_policy
        puts "Credstash policy created"
      rescue Aws::IAM::Errors::EntityAlreadyExists
        puts "Credstash policy already created"

        policies = @client.list_policies({})
        arn = policies.policies.find { |policy| policy.policy_name == "#{@app_tag}-credstash-access" }.arn

        cred_stash_policy = @client.get_policy({
          policy_arn: arn
        })
      end

      begin
        self.attach_policy_to_role(cred_stash_policy.arn, role)
        puts "Credstash policy attached"
      rescue Exception => ex
        puts "Credstash policy already attached"
      end

      begin
        self.attach_policy_to_role("arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier", role)
      rescue Exception => ex
        puts "AWSElasticBeanstalkWebTier policy already attached"
      end

      begin
        @client.create_instance_profile({
          instance_profile_name: role_name
        })
        puts "Instance profile created"
      rescue Exception => ex
        puts "Instance profile already created"
      end

      begin
        @client.add_role_to_instance_profile({
          instance_profile_name: role_name,
          role_name: role_name
        })
        puts "Role added to instance profile"
      rescue Exception => ex
        puts "Role has already been added to instance profile"
      end
    end

    private

    def self.create_role
      policy_doc = {
        Version:"2012-10-17",
        Statement:[
          {
            Effect:"Allow",
            Principal:{
              Service:"ec2.amazonaws.com"
            },
            Action:"sts:AssumeRole"
          }
        ]
      }

      role = @iam.create_role({
               role_name: "#{@app_tag}-beanstalk-EC2",
               assume_role_policy_document: policy_doc.to_json
             })

      return role
    end

    def self.create_cred_stash_policy
      role_policy_document = {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": "#{@options[:kms_arn]}"
          },
          {
            "Action": [
              "dynamodb:GetItem",
              "dynamodb:Query",
              "dynamodb:Scan"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:#{@options[:aws_region]}:#{@options[:aws_account_id]}:table/#{@app_tag}"
          }
        ]
      }.to_json

      cred_stash_policy = @iam.create_policy({
        policy_name: "#{@app_tag}-credstash-access",
        policy_document: role_policy_document
      })

      cred_stash_policy
    end

    def self.attach_policy_to_role(policy_arn, role)
      role.attach_policy({
        policy_arn: policy_arn
      })
    end

  end
end
