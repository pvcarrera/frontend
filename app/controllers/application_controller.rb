class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authentication
  include Localisation

  COOKIE_MESSAGE_COOKIE_NAME  = '_cookie_notice'
  COOKIE_MESSAGE_COOKIE_VALUE = 'y'

  DISMISS_BETA_OPT_OUT_COOKIE_NAME  = 'dismiss_opt_out'
  DISMISS_BETA_OPT_OUT_COOKIE_VALUE = 'y'

  before_action :store_return_to_location

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def cookies_not_accepted?
    cookies.permanent[COOKIE_MESSAGE_COOKIE_NAME] != COOKIE_MESSAGE_COOKIE_VALUE
  end

  helper_method :cookies_not_accepted?

  def dismissed_beta_opt_out?
    cookies.permanent[DISMISS_BETA_OPT_OUT_COOKIE_NAME] == DISMISS_BETA_OPT_OUT_COOKIE_VALUE
  end

  helper_method :dismissed_beta_opt_out?

  def display_search_box_in_header?
    true
  end

  helper_method :display_search_box_in_header?

  def display_menu_button_in_header?
    true
  end

  helper_method :display_menu_button_in_header?

  def display_skip_to_main_navigation?
    true
  end

  helper_method :display_skip_to_main_navigation?

  def alerts?
    flash.keys.any?
  end

  helper_method :alerts?

  private

  def store_return_to_location
    session[:return_to] = request.fullpath
  end

  def category_tree
    @category_tree ||= Core::CategoryTreeReader.new.call
  end

  def category_navigation
    @category_navigation ||= CategoryNavigationDecorator.decorate_collection(category_tree.children)
  end

  helper_method :category_navigation
end
