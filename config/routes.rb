Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create]

      namespace :accounts do
        get :show_balance
        get :show_limit
        put :update_limit
      end

      namespace :transactions do
        get :statement
        put :deposit
        put :withdraw
        put :transfer
      end
    end
  end
end
