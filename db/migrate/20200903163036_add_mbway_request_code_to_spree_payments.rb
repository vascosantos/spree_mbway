class AddMBWayRequestCodeToSpreePayments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_payments, :mbway_request_code, :string
  end
end
