module Spree
  module Admin
    module MBWayProvidersHelper

      def mbway_provider_status(provider)
        provider.active? ? Spree.t(:active) : Spree.t(:inactive)
      end

      def action_to_toggle_mbway_provider_status(provider)
        provider.active? ? Spree.t(:deactivate) : Spree.t(:activate)
      end

    end
  end
end