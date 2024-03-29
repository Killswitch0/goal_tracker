require_relative 'boot'

require 'rails/all'
require 'rake'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GoalTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.available_locales = %i[en uk]
    config.i18n.default_locale = :en

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true

      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # path for noticed gem folders
    config.autoload_paths += Dir[Rails.root.join('app', 'notifications', '*')]

    config.active_job.queue_adapter = :sidekiq

    config.after_initialize do
      GoalTracker::Application.load_tasks
      Rake::Task['deadline_notifications:goal_deadline_notify'].invoke
    end
  end
end
