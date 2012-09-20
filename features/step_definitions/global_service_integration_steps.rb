Then /^the global (header)(?: for a (site) section)? should have the correct structure$/ do |page_type, section|
  case [page_type, section]
  when ['header', nil]
    page.has_selector?('head')
  when ['header','site']
    page.has_selector?('li.forum.current')
  end
end

Then /^the global (header|footer)(?: for a (site) section)? should have the correct content$/ do |page_type, section|
  case [page_type, section]
  when ['header', nil]
    page.has_content? 'Search Lonely Planet'
    page.has_content? 'Home'
  when ['footer', nil]
    page.has_content? 'Newsletter'
    page.has_content? 'About us'
  end
end
