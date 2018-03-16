class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  around_action :setup_granite_view_context
  before_action { view_context }

  protected
  def setup_granite_view_context(&block)
    Granite.with_view_context(view_context, &block)
  end
end
