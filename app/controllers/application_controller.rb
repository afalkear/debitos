class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :authenticate_user!
  before_filter :require_padma_account
  before_filter :set_current_account
  before_filter :set_timezone
  #config.filter_parameters << :card_number

  # CAS user must have a PADMA account
  def require_padma_account
    if signed_in?
      unless current_user.padma_enabled?
        render text: 'Access allowed to PADMA users only - Think this is a mistake? Maybe PADMA Authentication service is down.'
      end
    end
  end

  def set_current_account
    if signed_in? && current_user.padma_enabled?
      current_user.current_account = Account.find_or_create_by(name: current_user.padma.current_account_name)
    end
  end

  def current_account
    current_user.current_account
  end

  def set_timezone
    if signed_in? && current_user.padma_enabled?
      Time.zone = current_user.current_account.padma.timezone
    end
  end
end
