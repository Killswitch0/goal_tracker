require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id] ||
      request.cookie_jar.encrypted[:user_id]

    User.find_by(id: user_id)&.admin_role?
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/, defaults: { locale: :en } do

    resource :calendar, only: :show, controller: :calendar

    resource :goal_tracking, controller: :goal_tracking
    resource :task_tracking, controller: :task_tracking

    # Goals
    resources :goals do
      member do
        get 'invite'
        post 'create_invitation'
        patch 'confirm_invitation'
        patch 'decline_invitation'
        delete 'leave'
      end

      get '/habit_chart', to: 'charts#habit', as: 'habit_chart'
      get '/task_chart', to: 'charts#task', as: 'task_chart'
    end

    resources :goals do
      resources :habits, except: %i[show] do
        member do
          get 'complete'
        end
      end

      resources :tasks, except: %i[show] do
        member do
          get 'complete'
        end
      end
    end

    resources :categories
    resources :tasks
    resources :habits

    # Users
    resources :users, except: :new do
      member do
        get :confirm_email
      end
    end

    # Sign up
    get "signup", to: "users#new"
    post "signup", to: "users#create"

    # Log in
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"

    # Log out
    get "logout", to: "sessions#destroy"

    # Password reset
    resources :password_resets, only: %i[new create edit update]

    # Pages
    get "home", to: "pages#home"
    get "about", to: "pages#about"

    # Dashboard
    get "dashboard", to: "dashboard#show"

    resources :dashboard_tasks, only: %i[new create] do
      member do
        get 'complete'
      end
    end

    resources :dashboard_habits, only: %i[new create] do
      member do
        get 'complete'
      end
    end

    # Chart
    resource :chart do
      member do
        get 'habit'
        get 'task'
      end
    end

    root "goals#index"
  end
end
