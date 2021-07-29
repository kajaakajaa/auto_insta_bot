module AjaxHelper
  extend ActiveSupport::Concern
  included do
    def ajax_redirect_to(redirect_uri)
      { js: "window.location.replace('#{redirect_uri}');" }
    end
  end
end