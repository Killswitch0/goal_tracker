module BootstrapIconHelper
  def icon(name)
    %Q{
      <i class="bi bi-#{name}"></i>
    }.html_safe
  end
end