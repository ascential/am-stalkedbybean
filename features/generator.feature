Feature: Generating config files
In order to have users follow a config template
As a deployment assistant
I want stalkedbybean to generate a config file

  Scenario: Init
    When I run `stalkedbybean init test`
    Then the following files should exist:
      | config/config_test.yml |
    Then the file "config/config_test.yml" should contain:
      """
      # MANDATORY OPTIONS TO BE FILLED UP BEFORE SETTING UP SECRETS
      app_name:
      aws_profile:
      aws_region:
      environment: test

      # MANDATORY OPTIONS TO BE FILLED UP BEFORE SETTING UP ROLES
      aws_account_id:
      kms_arn:

      # MANDATORY OPTIONS FOR PROVISIONNING
      vpc_id:
      vpc_security_groups:
        -
      instance_count:
      instance_size:
      platform_arn:
      env_vars: "KEY=value"
      vpc_ec2_subnets:
        -
        -
      vpc_elb_subnets:
        -
        -
      key_name:
      elb_type: "classic" # accepted values are : classic, application, network
      """
    Then the following files should exist:
      | config/.stalkedbybean.yml |
    Then the file "config/.stalkedbybean.yml" should contain:
      """
      # THIS WILL BE THE DEFAULT CONFIG FILE THAT WILL BE PASSED TO YOUR COMMANDS IF YOU DO NOT OVVERRIDE WITH -F FLAG.
      # YOU CAN CHANGE IT IF YOU WANT YOUR DEFAULT CONFIG FILE TO BE SOMETHING ELSE.
      default: "config/config_test.yml"
      """
