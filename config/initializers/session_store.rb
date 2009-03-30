# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_erlangblogs_session',
  :secret      => 'ee8d193b861ee70f460cd79b72b44616f085d0813126c2259ed401606aac5eb47183f4c980b79191c9f4eaaa0698664a56346ca83bb2f4915ac42290643bdb66'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
