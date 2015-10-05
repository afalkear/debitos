HYDRA = Typhoeus::Hydra.new

module Accounts
  API_KEY = ENV['accounts_key']
end

module Contacts
  HYDRA = ::HYDRA
  API_KEY = ENV['contacts_key']
end

module Fnz
  HYDRA = ::HYDRA
  API_KEY = ENV['fnz_key']
end