module Spree
  class MBWayProvider < ActiveRecord::Base
  	has_many :payments
    validates :name, :key, presence: true
    
    scope :active, -> { where(active: true) }

    API_BASE_URL = "https://www.ifthenpay.com/mbwayws/IfthenPayMBW.asmx"
    API_SET_URL = API_BASE_URL + "/SetPedidoJSON"
    API_STATE_URL = API_BASE_URL + "/EstadoPedidosJSON"
  end
end
