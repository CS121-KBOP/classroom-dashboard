Rails.application.routes.draw do
    get 'homepage/index'

    get "/login", to: redirect("/auth/google_oauth2")
    get "/auth/google_oauth2/callback", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/logout", to: "sessions#destroy"

    get    '/users/:user_id/courses/:id/flashcard',  to: 'courses#flashcard'

    get    '/users/:assignment_id/search',  to: 'submissions#search'

    get    '/:assignment_id', to: 'submissions#new'
    post   '/:assignment_id', to: 'submissions#create'
    post   '/users/:user_id/courses/:id/assignments/:assignment_id/submissions/:id/edit', to: 'submissions#update'

    resources :users do
        resources :courses do
            resources :students do
                collection do
                    post :import
                end
            end
            resources :assignments do
                resources :submissions
            end
        end
    end

    resource :session, only: [:create, :destroy]

    root 'homepage#index'
end
