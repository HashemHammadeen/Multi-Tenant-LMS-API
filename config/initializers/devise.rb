# frozen_string_literal: true

# Devise setup
Devise.setup do |config|
  # Mailer
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # ORM
  require 'devise/orm/active_record'

  # Authentication keys
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Skip session storage for APIs
  config.skip_session_storage = [:http_auth]

  # Password hashing
  config.stretches = Rails.env.test? ? 1 : 12

  # Confirmable
  config.reconfirmable = true

  # Rememberable
  config.expire_all_remember_me_on_sign_out = true

  # Password validation
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Recoverable
  config.reset_password_within = 6.hours

  # Navigation and sign out
  config.sign_out_via = :delete

  # Hotwire/Turbo
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # JWT Configuration
  Devise.setup do |config|
    # ... other devise config ...

    config.jwt do |jwt|
      jwt.secret = Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
      jwt.dispatch_requests = [
        ['POST', %r{^/api/v1/login$}],
        ['POST', %r{^/users/sign_in$}]
      ]
      jwt.revocation_requests = [
        ['DELETE', %r{^/api/v1/logout$}],
        ['DELETE', %r{^/users/sign_out$}]
      ]
      jwt.expiration_time = 1.day.to_i
    end

  # Make sure navigational formats is empty for API
  config.navigational_formats = []
  end
end
