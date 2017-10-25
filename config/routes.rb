Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats
  resources :cat_rental_requests

  patch "cat_rental_requests/:id/approve", to: "cat_rental_requests#approve", as: 'approve'
  patch "cat_rental_requests/:id/deny", to: "cat_rental_requests#deny", as: 'deny'
end
