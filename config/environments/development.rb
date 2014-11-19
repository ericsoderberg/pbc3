Pbc3::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.asset_host = "http://localhost"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  
  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Only use best-standards-support built into browsers
  ###config.action_dispatch.best_standards_support = :builtin
  
  config.action_mailer.default_url_options = { :host => 'UNCONFIGURED' }
  
  config.time_zone = "Pacific Time (US & Canada)"
  
  config.after_initialize do
    #Configuration.mailman_dir = '/usr/local/bin'
    #Configuration.mailman = '/tmp/py27/bin/mailman'
    Configuration.paypal_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  end
end
