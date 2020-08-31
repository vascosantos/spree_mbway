class AddMobileNumberToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_payments, :mbway_mobile_number, :string, limit: 20
  end
end
