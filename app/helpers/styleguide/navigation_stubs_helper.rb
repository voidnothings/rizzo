module Styleguide::NavigationStubsHelper

  def left_nav_stub
    {
      groups: [
        {
          title: nil,
          items: [
            {
              name: 'All',
              path: '#'
            }
          ]
        },
        {
          title: "Sections",
          items: [
            {
              name: 'Articles',
              path: '#'
            },
            {
              name: 'Things to do',
              path: '#'
            }
          ]
        },
        {
          title: "Collections",
          items: [
            {
              name: 'Top places to stay in Edinburgh',
              path: '#'
            },
            {
              name: 'Best things to do in Scotland',
              path: '#'
            }
          ]
        }
      ]
    }
  end

end