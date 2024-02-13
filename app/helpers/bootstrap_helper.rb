module BootstrapHelper
  def icon(name, style: '')
    %(
      <i class="bi bi-#{name}" style="#{style}"></i>
    ).html_safe
  end

  def canvas_button(name, icon: '', klass: '', style: '')
    %(
      <button class="btn btn-primary #{klass}" style="#{style}" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasExample" aria-controls="offcanvasExample">
        #{icon("#{icon}") if icon}
        <span>#{t(name)}</span>
      </button>
    ).html_safe
  end

  def confirmation_dialog_button(name, id, action_id: '', klass: 'btn btn-sm btn-danger')
    %(
      <button type="button" class="#{klass}" data-bs-toggle="modal" data-bs-target="#exampleModal#{action_id.capitalize}#{id}">
        #{t(name)}
      </button>
    ).html_safe
  end
end
