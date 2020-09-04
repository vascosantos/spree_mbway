class AddMBWayProviderIdToSpreePayments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_payments, :mbway_provider_id, :integer
  end
end
