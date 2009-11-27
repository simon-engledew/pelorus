module Settings
  class << self

      def [](key)
        (@settings || Settings.reload!)[key.to_s]
      end

      def enabled?(feature)
        (Settings[:enabled] || {})[feature.to_s]
      end

      def reload!
        @settings = {}.tap do |config|
          config.merge!(YAML.load_file(Rails.root.join('config', 'settings.yml'))[Rails.env] || {})
        end
      end
      
    end
end