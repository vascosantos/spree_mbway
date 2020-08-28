Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :mbway_providers, :except => [:show, :destroy] do
      put :toggle_activation, :on => :member
    end
  end
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :payments do
        get 'capture_mbway_payment', on: :collection
      end
    end
  end
end
