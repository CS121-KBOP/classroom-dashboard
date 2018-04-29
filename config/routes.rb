Rails.application.routes.draw do
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
    post   '/users/:user_id/courses/:id', to: 'courses#edit_flashcard_order'


    # Poll routes
    get    '/p/:access_tag', to: 'polls#student_show'
    get    '/p/:access_tag/o/:option_id/select', to: 'options#select'
    get    'user/:user_id/course/:course_id/poll/:id/data', to: 'polls#get_data'


    # Assignment routes
    get    '/a/:access_tag/search',  to: 'submissions#search'
    get    '/a/:access_tag', to: 'submissions#new'
    post   '/a/:access_tag', to: 'submissions#create'
    post   '/users/:user_id/courses/:id/assignments/:assignment_id/submissions/:id/edit', to: 'submissions#update'
    get    '/users/:user_id/courses/:course_id/assignments/:id/submissions', to: 'assignments#get_submission_data'

    # frontpage/submission routes
    get 'homepage/index'
    get    '/:access_tag', to: 'homepage#access_submission_page'

    resources :users do
        resources :courses do
            resources :students do
                collection do
                    post :import
                end
            end
            resources :polls do
                resources :options
            end
            resources :assignments do
                resources :submissions
            end
        end
    end

    resource :session, only: [:create, :destroy]

    root 'homepage#index'
end
