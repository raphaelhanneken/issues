module AjaxRedirect
  extend ActiveSupport::Concern

  def redirect_ajax_to(resource, options = {})
    get_flash_messages(options)
    render js: "window.location = '#{url_for(resource)}'"
  end

  private

    def get_flash_messages(options = {})
      if options[:flash]
        flash[:success] = options[:flash][:success] unless options[:flash][:success].nil?
        flash[:error]   = options[:flash][:error]   unless options[:flash][:error].nil?
        flash[:notice]  = options[:flash][:notice]  unless options[:flash][:notice].nil?
        flash[:info]    = options[:flash][:info]    unless options[:flash][:info].nil?
      end
    end
end
