# Be sure to restart your server when you modify this file.

Debitos::Application.config.session_store :cookie_store, key: '_debitos_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Debitos::Application.config.session_store :active_record_store

# needed for activerecord-session_store in rails 4.0.0
#ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
