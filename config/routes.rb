Rails.application.routes.draw do
    resources :killboard
    
    root 'killboard#index'
    
    post  '/',  to: 'killboard#create'
    post  '/submit',  to: 'killboard#create'

    get '/kill/:id', to: 'killboard#show'
    
    get '/user/:id', to: 'killboard#user'
    get 'system/:name', to: 'killboard#system'
    get 'corporation/:id', to: 'killboard#corporation'

end
