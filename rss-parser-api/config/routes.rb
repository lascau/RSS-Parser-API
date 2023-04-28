Rails.application.routes.draw do
  resources :news do
    collection do
      get 'bulk_insert'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
