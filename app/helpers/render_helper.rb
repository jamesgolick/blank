module RenderHelper
  def render_flash
    render :partial => "shared/flash", :object => flash
  end

  def render_session_toolbar
    render :partial => 'shared/session_toolbar' if logged_in? && !controller.is_a?(SessionsController)
  end
end
