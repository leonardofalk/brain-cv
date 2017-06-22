Rails.application.routes.draw do
  root to: 'images#index'

  resources :images do
    member do
      get :data
      get :data_analyzed
    end
  end
end
