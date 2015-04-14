# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( signup_flow.js admin_record.js signup_show.js cc_validations.js style.css email.css new_homepage.js estimator.js bootstrap-datepicker-parent.js faq.js pricing_boxes.js )
