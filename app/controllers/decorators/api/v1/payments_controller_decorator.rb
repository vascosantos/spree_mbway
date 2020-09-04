module Decorators::Api::V1::PaymentsControllerDecorator

  def self.prepended(base)
    base.skip_before_action :find_order, only: [:capture_mbway_payment]
    # base.before_action :find_order_and_payment, only: [:capture_mbway_payment]
  end

  def capture_mbway_payment
    find_order_and_payment
    if @payment && @order && params[:referencia] == @order.number && params[:valor].to_d == @payment.amount && params[:idpedido] == @payment.mbway_request_code
      @order.resume! if @order.state == "canceled"
      capture
      ## Send push notification
      if Spree::Config.has_preference?(:send_push_notifications) && Spree::Config[:send_push_notifications]
        NewOrderNotifyJob.perform_later(@order)
      end
      ## Handle invoice and email
      if Spree::Config.has_preference?(:automatic_invoices) && Spree::Config[:automatic_invoices]
        ## Create invoice and send paid email
        if Object.const_defined?("NewCreateInvoiceJob")
          NewCreateInvoiceJob.perform_later(@order, "paid_email")
        else
          ## Only send paid email
          @order.send_paid_email if @order.respond_to?(:send_paid_email)
        end
      else
        ## Only send paid email
        @order.send_paid_email if @order.respond_to?(:send_paid_email)
      end
      head :ok
    else
      head :not_found
    end
  end

  private

    def find_order_and_payment
      @order = Spree::Order.find_by_number(params[:referencia])
      if @order
        @payment = @order.payments.where(mbway_request_code: params[:idpedido]).last
        authorize! :read, @order, order_token
      end
    end
end

::Spree::Api::V1::PaymentsController.prepend(Decorators::Api::V1::PaymentsControllerDecorator)