require 'aws-sdk-kms'
require 'Shellwords'

module Stalkedbybean
  class SecretsSetup

    def self.parse_options(filepath, options)
      @options = self.load_default_options(filepath)
      @options.merge!(options)
      @app_tag = "#{@options[:app_name]}-#{@options[:environment]}"
    end

    def self.load_default_options(file_path)
      default_options = YAML::load(open(file_path))
      convert_options_to_symbols = default_options.map { |option, default_value| [option.to_sym, default_value] }
      Hash[convert_options_to_symbols]
    end

    def self.create_key
      @client = Aws::KMS::Client.new(region: "#{@options[:aws_region]}", profile: "#{@options[:aws_profile]}")
      key = @client.create_key({})
      @client.create_alias({
        alias_name: "alias/#{@options[:app_name]}",
        target_key_id: key[:key_metadata][:key_id]
        })

      puts "Your KMS ARN is: #{key[:key_metadata][:arn]}"
    end

    def self.create_credstash_table
      system("credstash -r #{@options[:aws_region]} -p #{@options[:aws_profile]} -t #{@app_tag} setup")
      puts "Credstash table #{@app_tag} created."
    end

    def self.add_secret(key, value)
      raise(StandardError, "Missing or invalid key/value") if key == nil || value == nil
      system("credstash -r #{@options[:aws_region]} -p #{@options[:aws_profile]} -t #{@app_tag} put -k alias/#{@options[:app_name]} #{key} #{value}")
    end

    def self.get_secret(key)
      raise(StandardError, "Missing or invalid key") if key == nil
      system("credstash -r #{@options[:aws_region]} -p #{@options[:aws_profile]} -t #{@app_tag} get #{key}")
    end
  end
end