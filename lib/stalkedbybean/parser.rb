module Stalkedbybean
  module Parser
    extend self

    CONFIG_SETTINGS_FILE = "config/.stalkedbybean.yml"

    def parse_options(file_path, options)
      file_path ||= get_default_file_path
      default_options = load_default_options(file_path)
      parsed_options = symbolize_option_names(options)
      default_options.merge!(parsed_options)
    end

    def load_default_options(file_path)
      default_options = YAML::load(open(file_path))
      symbolize_option_names(default_options)
    end

    def symbolize_option_names(options)
      options.map { |key, value| [key.to_sym, value] }.to_h
    end

    def get_default_file_path
      settings = YAML::load_file(CONFIG_SETTINGS_FILE)
      settings["default"]
    end

  end
end
