Rails.application.routes.draw do
  resources :users, except: :new do
    member do
      get :confirm_email
    end
  end

  resources :categories do
    resources :goals
  end

  resources :goals do
    resources :habits, except: %i[ show ]

    resources :tasks, except: %i[ show ]
  end

  resources :password_resets

  get "goals/:id/tasks/:id", to: "tasks#complete", as: "complete_task"
  get "goals/:id/habits/:id", to: "habits#completed_habit", as: "complete_habit"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  get "logout", to: "sessions#destroy"

  get "home", to: "pages#home"
  get "about", to: "pages#about"


  root "categories#index"
end
