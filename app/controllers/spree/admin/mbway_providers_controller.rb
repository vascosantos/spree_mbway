module Spree
  module Admin
    class MBWayProvidersController < ResourceController
      def index
        @search = Spree::MBWayProvider.ransack(params[:q])
        @mbway_providers = @search.result.page(params[:page])
      end

      def toggle_activation
        @success = @mbway_provider.toggle!(:active)
      end
    end
  end
end
