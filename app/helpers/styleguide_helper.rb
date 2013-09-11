module StyleguideHelper

  def left_nav
    {
      groups: [
        {
          title: "Sections",
          items: [
            {
              name: 'Cards',
              path: '/styleguide',
              extra_style: "nav__item--delimited"
            },
            {
              name: 'Navigation',
              path: '/styleguide/navigation',
              extra_style: "nav__item--delimited"
            }
          ]
        }
      ]
    }
  end

  def ad_config
    {hints: "", channels: ""}
  end

  def ui_component(path, opts)
    render "components/#{path}", opts
  end

  def sg_component(path, opts)
    capture_haml do
      haml_tag(:div, class: "styleguide-block") do
        haml_tag(:div, class: "styleguide-block__item") do
          haml_concat ui_component(path, opts)
        end
        haml_concat render "styleguide/partials/description", component: path, opts: opts[:original_stub] ? {stack_item: opts[:original_stub]} : opts
      end
    end
  end

end