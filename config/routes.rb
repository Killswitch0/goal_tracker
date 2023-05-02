Rails.application.routes.draw do
  resources :users, except: :new

  resources :categories do
    resources :goals
  end

  resources :goals do
    resources :habits, except: %i[ show ]

    resources :tasks, except: %i[ show ]
  end


  get "goals/:id/tasks/:id", to: "tasks#complete", as: "complete_task"
  get "goals/:id/habits/:id", to: "habits#complete", as: "complete_habit"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  get "logout", to: "sessions#destroy"

  get "home", to: "pages#home"
  get "about", to: "pages#about"
  # delete "logout", to: "sessions#destroy"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "categories#index"
end
