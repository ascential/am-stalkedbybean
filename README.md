# Stalkedbybean

Little Ruby command line utility to help Ascential Makers to deploy on AWS beanstalk. Configurable through command line and config file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stalkedbybean'
```

And then execute:

```ruby
$ bundle install
```

Or install it yourself as:

```
$ gem install stalkedbybean
```

## How to use

You can perform all the steps for deploying your app (initializing it, handling secrets, creating the environment, deploying the version and terminating environment finally) by running a simple Ruby script.

1. This gem relies on some dependencies ([AWS CLI](https://aws.amazon.com/cli/), [AWS EB CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html) and [Credstash](https://github.com/fugue/credstash)) you will have to install.
```
$ pip3 install awscli --upgrade --user
$ pip3 install awsebcli --upgrade --user
$ pip3 install boto botocore boto3
$ pip3 install credstash
```

2. Make sure you have your AWS credentials set up. If not, you can do so by [following the instructions here.](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

3. Initialise a default config file in your project's root directory. Replace `your-environment-name` which whatever applies to you (eg; test, staging, production etc). This should generate a [config file](./config/config_test.yml) and [config settings file](./config/.stalkedbybean.yml) in the directory you are in.
```
$ stalkedbybean init your-environment-name
```

4. Update the generated [config file](./config/config_test.yml) with the config options relevant to _your_ app especially the mandatory ones for setting up secrets. You won't be able to get your `kms_arn` until you set up your secrets below so leave that for now.

Detailed information on how to update your config options [can be found here](./docs/setting_up_config_file.md).

5. The generated file will automatically be set as your default config file. You can override this by passing it with the flag ```-f FILENAME``` when running the gem commands or changing the default file in `config/.stalkedbybean.yml`.

## Commands Details

```bash
stalkedbybean init                            # Generates a config file
stalkedbybean create [OPTIONS]                # Creates a new AWS application
stalkedbybean secrets <command> [OPTIONS]     # Sets up and manages secrets using Credstash
stalkedbybean setup_roles [OPTIONS]           # Sets up roles in AWS IAM
stalkedbybean provision -v VERSION [OPTIONS]  # Provisions new environment in AWS EB
stalkedbybean deploy -v VERSION [OPTIONS]     # Deploys new version of environment
stalkedbybean terminate [OPTIONS]             # Terminates environment, application and all resources
stalkedbybean update_config [OPTIONS]         # Updates all config options
stalkedbybean print_env_vars [OPTIONS]        # Prints existing environment variables
stalkedbybean update_env_vars [OPTIONS]       # Updates environment variables
stalkedbybean versions [OPTIONS]              # Displays application versions
stalkedbybean help [COMMAND]                  # Describe available commands or one specific command
```

## Handling Secrets

The Beanstalk platform expects secrets to be put using [CredStash](https://github.com/fugue/credstash), in the same region that you are deploying, using a table called `your_app_name-your_environment_name`, encrypted through a KMS key.

This can be done using `stalkedbybeans`.

1. Make sure you have the `config.yml` file with the mandatory options for setting up secrets filled up correctly.

2. Create a KMS key and setup a table to hold your secrets. This step will also print out your KMS ARN which you should copy and paste into your [config.yml file](./config/config_test.yml) as it will be required for deployment.
```bash
$ stalkedbybeans secrets setup
```

3. To add a secret in a key/value pair:
```bash
$ stalkedbybeans secrets add [key] [value]
```

4. To get a secret:
```bash
$ stalkedbybeans secrets get [key]
```

5. You can also change the value of an existing secret by creating a new version of it. Credstash will automatically use the latest version of the secret.
```bash
$ stalkedbybeans secrets change [key] [new_value] [version]
```

6. To get all the secrets stored within your application:
```bash
$ stalkedbybeans secrets getall
```

If you do not want to use the script, you can also use Credstash [manually as described here](./docs/setting_up_credstash.md).

Keys are versioned. See [CredStash documentation](https://github.com/fugue/credstash) for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `rake features` for the cucumber test. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ascential/stalkedbybean.

## License

The gem is available as open source under the terms of the [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
