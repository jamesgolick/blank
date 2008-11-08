module RenderHelper
  def render_flash
    render :partial => "shared/flash", :object => flash
  end
end
