require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StorageRailsApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_specs: false,
            helper_specs: false,
            routing_specs: true,
            controller_specs: true,
            request_specs: false
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: 'storage_rails_app_dev',
        access_key_id: 'AKIAISMURECTFTQXY7QA',
        secret_access_key: '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'
      },
      path: '/box-images/:id-:hash:extension',
      hash_secret: 'f0062baa67179e4a5aeb642688ed6785817f5ab81328350e41a4188a91660ac5a79eeae051ee7707ba6cd06838385bffad45f98563bac09b79c7e4d9712e7478'
    }
  end
end
