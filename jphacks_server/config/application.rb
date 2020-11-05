require_relative 'boot'
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Vele
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = ENV["TZ"]
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "*.yml").to_s]
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml").to_s]
    config.active_support.escape_html_entities_in_json = true
    config.filter_parameters += [:password]
    config.encoding = "utf-8"
    config.generators.template_engine = :slim
    config.generators.system_tests = nil
  end
end
