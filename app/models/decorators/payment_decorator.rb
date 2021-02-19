module Decorators::PaymentDecorator
  def self.prepended(base)
    base.before_create :assign_mbway_provider
    base.belongs_to :mbway_provider
    base.scope :from_mbway, -> { joins(:payment_method).where(spree_payment_methods: { type: 'Spree::PaymentMethod::MBWay' }) }
  end

  def assign_mbway_provider
    if self.payment_method.type == 'Spree::PaymentMethod::MBWay' && Spree::MBWayProvider.active.any?
      self.mbway_provider = Spree::MBWayProvider.active.first
    end
  end

  def start_mbway_payment(description)
    if self.payment_method.type == 'Spree::PaymentMethod::MBWay'
      response = self.payment_method.send_request(self.mbway_provider.key, self.order.number, self.amount.to_f, self.mbway_mobile_number, description)
      if response && response["IdPedido"]
        self.update(mbway_request_code: response["IdPedido"])
      end
      response && response["MsgDescricao"]
    else
      nil
    end
  end

  def check_mbway_payment
    if self.payment_method.type == 'Spree::PaymentMethod::MBWay'
      response = self.payment_method.request_status(self.mbway_provider.key, self.mbway_request_code)
      response && response["EstadoPedidos"] && response["EstadoPedidos"].first["MsgDescricao"]
    else
      nil
    end
  end
end

::Spree::Payment.prepend(Decorators::PaymentDecorator)