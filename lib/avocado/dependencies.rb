module Avocado
  module Dependencies

    class << self

      def rails3?
        safe_gem_check("rails", ">= 3.0")
      end

      def rails_3_asset_pipeline?
        rails3? && Rails.respond_to?(:application) && Rails.application.respond_to?(:assets) && Rails.application.assets
      end

      private
      def safe_gem_check(gem_name, version_string)
        if Gem::Specification.respond_to?(:find_by_name)
          Gem::Specification.find_by_name(gem_name, version_string)
        elsif Gem.respond_to?(:available?)
          Gem.available?(gem_name, version_string)
        end
      rescue Gem::LoadError
        false
      end

    end
  end
end
