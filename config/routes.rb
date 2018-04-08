Rails.application.routes.draw do
    get 'homepage/index'

    # Login/OAuth routes
    get "/login", to: redirect("/auth/google_oauth2")
    get "/auth/google_oauth2/callback", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/logout", to: "sessions#destroy"

    # Student Roster routes
    get    '/users/:user_id/courses/:id/student_index', to: 'courses#student_index'

    # Flashcard routes
    get    '/users/:user_id/courses/:id/flashcard',  to: 'courses#flashcard'
    get    '/users/:user_id/courses/:id/quiz',  to: 'courses#quiz'
    post   '/users/:user_id/courses/:id/update_notes',  to: 'courses#updateNotes'

    # Poll routes
    get    '/poll/:poll_id', to: 'polls#student_show'

    # Assignment/Submission routes
    get    '/:assignment_id/search',  to: 'submissions#search'
    get    '/:assignment_id', to: 'submissions#new'
    post   '/:assignment_id', to: 'submissions#create'
    post   '/users/:user_id/courses/:id/assignments/:assignment_id/submissions/:id/edit', to: 'submissions#update'
    get    '/users/:user_id/courses/:course_id/assignments/:id/submissions', to: 'assignments#submission_view'

    resources :users do
        resources :courses do
            resources :students do
                collection do
                    post :import
                end
            end
            resources :polls do
                resources :options do
                    member do
                        post :select
                    end
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
