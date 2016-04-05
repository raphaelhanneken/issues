module NavbarLinkHelper
  def navigation_link_to(url, html_options = {}, &block)
    # link_to(name, url, html_options.merge(class: (current_page?(url) ? 'active' : '')))
    content_tag(:li, class: 'nav-item' + (current_page?(url) ? ' active' : '')) do
      link_to(url, html_options, &block)
    end
  end
end
