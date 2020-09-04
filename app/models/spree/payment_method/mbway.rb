module Spree
  class PaymentMethod::MBWay < PaymentMethod
    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def source_required?
      false
    end
      
    def credit(money, credit_card, response_code, options = {})
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end


    # The following code is specific to the IfThenPay service
    API_BASE_URL = "https://www.ifthenpay.com/mbwayws/IfthenPayMBW.asmx"

    def send_request(mbway_key, order_number, order_amount, mobile_number, description)
      if self.active?
        request_params = {
          MbWayKey: mbway_key,
          canal: "03",
          referencia: order_number,
          valor: order_amount.to_s,
          nrtlm: mobile_number.gsub(/\s+/, ""),
          email: "",
          descricao: description
        }
        url = API_BASE_URL + "/SetPedidoJSON"
        # begin
          response = RestClient.post(url, request_params, {content_type: "application/x-www-form-urlencoded", accept: :json})
        # rescue => e
          # return e.response
        # end
        JSON.parse(response.body)
      else
        nil
      end
    end

    def request_status(mbway_key, request_code)
      if self.active?
        request_params = {
          MbWayKey: mbway_key,
          canal: "03",
          idspagamento: request_code
        }
        url = API_BASE_URL + "/EstadoPedidosJSON"
        # begin
          response = RestClient.post(url, request_params, {content_type: "application/x-www-form-urlencoded", accept: :json})
        # rescue => e
          # return e.response
        # end
        JSON.parse(response.body)
      else
        nil
      end
    end

  end
end

