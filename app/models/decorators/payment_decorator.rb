module Decorators::PaymentDecorator
  def self.prepended(base)
    base.belongs_to :mbway_provider
    base.scope :from_mbway, -> { joins(:payment_method).where(spree_payment_methods: { type: 'Spree::PaymentMethod::MBWay' }) }
  end
end

::Spree::Payment.prepend(Decorators::PaymentDecorator)