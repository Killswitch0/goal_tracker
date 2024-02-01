require 'sidekiq/web'
require 'sidekiq/cron/web'

class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id] ||
      request.cookie_jar.encrypted[:user_id]

    User.find_by(id: user_id)&.admin_role?
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  defaults = if Rails.env.test?
               { locale: :en }
             else
               {}
             end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/, defaults: defaults do
    
    root 'goals#index'

    resource :calendar, only: :show, controller: :calendar
    resource :goal_tracking, controller: :goal_tracking
    resource :task_tracking, controller: :task_tracking

    resources :charts, controller: :charts

    #Chart
    resource :chart do
      member do
        get 'habit'
        get 'task'
      end
    end

    get "/completed_tasks", to: "charts#completed_tasks"
    get "/uncompleted_tasks", to: "charts#uncompleted_tasks"
    get "/habits_by_completions", to: "charts#habits_by_completions"
    get "/tasks_chart", to: "charts#tasks"
    get "/habits_chart", to: "charts#habits"
    get "/habits_completions", to: "charts#habits_completions"

    resources :challenges do
      member do
        get 'add_goal'
        post 'add_goal'

        get 'create_invitation'
        post 'create_invitation'
        get 'invite'
        patch 'confirm_invitation'
        patch 'decline_invitation'
        delete 'leave'
        delete 'destroy_goal'
        delete 'destroy_user'
      end
    end

    # Goals
    resources :goals do
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
        delete :delete_image_attachment
      end
    end

    # Sign up
    get 'signup', to: 'users#new'
    post 'signup', to: 'users#create'

    # Log in
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'

    # Log out
    get 'logout', to: 'sessions#destroy'

    # Password reset
    resources :password_resets, only: %i[new create edit update]

    # Pages
    get 'home', to: 'pages#home'
    get 'about', to: 'pages#about'

    # Dashboard
    get 'dashboard', to: 'dashboard#show'

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
  end
end
