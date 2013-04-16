class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  #config.filter_parameters << :card_number
end
