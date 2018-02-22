Rails.application.routes.draw do
    get 'homepage/index'

    get "/login", to: redirect("/auth/google_oauth2")
    get "/auth/google_oauth2/callback", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/logout", to: "sessions#destroy"

    get    '/users/:user_id/courses/:id/flashcard',  to: 'courses#flashcard'

    resources :users do
        resources :courses do
            resources :students do
                collection do
                    post :import
                end
            end
        end
    end

    resource :session, only: [:create, :destroy]

    root 'homepage#index'
end
