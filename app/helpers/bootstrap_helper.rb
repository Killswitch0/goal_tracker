module BootstrapHelper
  def icon(name, style: '')
    %Q{
      <i class="bi bi-#{name}" style="#{style}"></i>
    }.html_safe
  end

  def canvas_button(name, klass: '', style: '')
    %Q{
      <button class="btn btn-primary #{klass}" style="#{style}" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasExample" aria-controls="offcanvasExample">
            #{t(name)}
          </button>
    }.html_safe
  end
end