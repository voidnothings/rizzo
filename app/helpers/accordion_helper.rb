module AccordionHelper

  MAX_NAV_ITEMS_PER_GROUP = 7

  def grouped_content_for(title, args = {}, &content)
    if args[:use_accordion]
      accordion_for(title, args, &content)
    else
      group_body_for(title, args, &content)
    end
  end

  def accordion_for(title, args = {}, &content)

    section = args[:section] || title.downcase.gsub(/\s/,'-')
    expand_text = args[:expand_text] || 'Show More ...'
    collapse_text = args[:collapse_text] || 'Show Less ...'

    capture_haml do
      haml_tag( :div, class: "accordion accordion--#{section}" ) do
        haml_tag( :input, id: "ac-#{section}", class: 'accordion__input', type: "checkbox", checked: args[:is_open] )
        haml_tag( :div, class: 'accordion__target accordion__target--large' ) do
          haml_concat group_body_for( title, {section: section}, &content)
        end
        haml_tag( :label, class: 'accordion__handler', for: "ac-#{section}", data: { expand: expand_text, collapse: collapse_text } )
      end
    end

  end

  def group_body_for(title, args = {}, &content)

    section  = args[:section] || title.downcase.gsub(/\s/,'-')

    capture_haml do
      haml_tag( :label, class: 'group__title--aside', for: "ac-#{section}" ) do
        haml_concat title
      end
      haml_tag( :div, id: "js-#{section}", class: 'group__body nav--stack' ) do
        if block_is_haml?(content)
          yield
        else
          haml_concat yield
        end
      end
    end

  end

end
