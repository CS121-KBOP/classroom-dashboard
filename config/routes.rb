Rails.application.routes.draw do
    get 'homepage/index'

    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    get    '/users/:user_id/courses/:id/flashcard',  to: 'courses#flashcard'

    resources :users do
        resources :courses do
            resources :students
            resources :assignments do
                resources :submissions
            end
        end
    end

    root 'homepage#index'
end
