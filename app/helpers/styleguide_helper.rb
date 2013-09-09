module StyleguideHelper

  include Styleguide::CardsStubsHelper
  include Styleguide::NavigationStubsHelper

  def left_nav
    {
      groups: [
        {
          title: "Sections",
          items: [
            {
              name: 'Cards',
              path: '/styleguide'
            },
            {
              name: 'Navigation',
              path: '/styleguide/navigation'
            }
          ]
        }
      ]
    }
  end

  def ad_config
    {hints: "", channels: ""}
  end

end