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

1. Initialise a default config file. Replace `your-environment-name` which whatever applies to you (eg; test, staging, production etc).
```
stalkedbybean init your-environment-name
```

2. Update the generated config file with the config options relevant to _your_ app especially the mandatory ones for setting up secrets. You won't be able to get your `kms_arn` until you set up your secrets below so leave that for now.

Detailed information on how to update your config options [can be found here.](./docs/config_file.md).

This will be the default config file. You have to pass it with the flag ```-f FILENAME``` when running the gem commands.

## Commands details

```bash
stalkedbybean init                            # Generates a config file
stalkedbybean create [OPTIONS]                # Creates a new AWS application
stalkedbybean secrets <command> [OPTIONS]     # Sets up secrets using credstash
stalkedbybean setup_roles [OPTIONS]           # Sets up roles in AWS IAM
stalkedbybean provision -v VERSION [OPTIONS]  # Provisions new environment in AWS EB
stalkedbybean deploy -v VERSION [OPTIONS]     # Deploys new version
stalkedbybean terminate [OPTIONS]             # Terminates environment
stalkedbybean update_config [OPTIONS]         # Updates new config
stalkedbybean print_env_vars [OPTIONS]        # Prints existing environment variables
stalkedbybean update_env_vars [OPTIONS]       # Updates environment variables
stalkedbybean versions [OPTIONS]              # Displays application versions
stalkedbybean help [COMMAND]                  # Describe available commands or one specific command
```

## Handling secrets

The Beanstalk platform expects secrets to be put using [CredStash](https://github.com/fugue/credstash), in the same region that you are deploying, using a table called `your_app_name-your_environment_name`, encrypted through a KMS key.

This can be done using `stalkedbybeans`.

1. Make sure you have the `config.yml` file with the mandatory options for setting up secrets filled up correctly.

2. Create a KMS key and setup a table to hold your secrets. This step will also print out your KMS ARN which you should copy and paste into your [config.yml file](./config.yml) as it will be required for deploymnent.
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

If you do not want to use the script, you can also use Credstash manually.

Key are versioned. See [CredStash documentation](https://github.com/fugue/credstash) for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ascential/stalkedbybean.

## License

The gem is available as open source under the terms of the [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
