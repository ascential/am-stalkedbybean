require 'thor/group'

module Stalkedbybean
  module Generators
    class Init < Thor::Group
      argument :name, :type => :string
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__) + "/init"
      end

      def create_group
        empty_directory('config')
      end

      def copy_config_file
        template("config.yml", "config/config_#{name}.yml")
      end

      def copy_config_settings
        template(".stalkedbybean.yml", "config/.stalkedbybean.yml")
      end
    end
  end
end
