class UserDecorator < ApplicationDecorator
  delegate_all

  def name_or_email
    return name if name.present?

    email.split('@')[0]
  end

  def gravatar(size: 30, css_class: '', style: '')
    # In decorators h means i want to use RoR helper
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.jpg?s=#{size}",
                class: "rounded #{css_class}", style: style,alt: name_or_email
  end
end
