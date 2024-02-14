class ApplicationNotifications < Noticed::Base
  include ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper

  def default_url_options
    { locale: I18n.locale }
  end
end
