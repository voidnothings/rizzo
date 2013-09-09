module NavItemHelper

  def nav_item_aside_style(section, current = false, extra_style = nil)

    default = 'nav__item--stack nav__item--chevron'
    js_scope = "js-#{section}-item"
    is_current = current ? 'nav__item--current--stack' : nil

    [default, js_scope, is_current, extra_style].compact.join(' ')

  end

  def nav_item_aside(item, section, extra_style = nil, opts = {})
    options = {
      :show_description => true
    }.merge(opts)

    item_title = item[:name] || item[:title]
    item_href = item[:path] || item[:href] || item[:url] || item[:slug]
    item_class = nav_item_aside_style(section, item[:current], extra_style)
    item_data = { 'item-kind' => "stack:#{section}" }
    capture_haml do
      haml_tag(:a, :href => item_href, :class => item_class, :data => item_data ) do
        haml_concat item_title
        if options[:show_description] && item[:description]
          haml_tag( :span, item[:description], :class => 'nav__standfirst' )
        end
        if item[:count]
          haml_tag( :span, item[:count], :class => 'facet--inline-count' )
        end
      end
    end
  end


  def nav_item_aside_article(item, section, extra_style = nil)
    item_title = item.first
    item_href  = "#{articles_path}/#{item.first.downcase.parameterize}"
    item_class = nav_item_aside_style(section, nil, extra_style)

    capture_haml do
      haml_tag(:a, :href => item_href, :class => item_class ) do
        haml_concat item_title
        haml_tag( :span, item.last, :class => 'facet--inline-count' )
      end
    end

  end

  def nav_root_item_aside(local, current, count)
    item = if current_path.include?('article')
       {
         name: "All Tips and Articles",
         href: "#{articles_path}"
       }
    else
      {
        name: "All #{local[:name]} Accommodation",
        href: local[:path]
      }
    end

    item.merge!( { current: current, count: count } )

    nav_item_aside(item, 'all')

  end

  def has_current_nav_item?(items)
    items.find{|item| item[:current] } ? true : false
  end

end
