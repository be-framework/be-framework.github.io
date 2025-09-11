module Jekyll
  module SidebarData
    def get_sidebar_pages(pages, lang)
      puts "SidebarData: Called for language: #{lang}"
      
      manual_pages = pages.select do |page|
        is_manual = page.data['category'] == 'Manual'
        is_correct_lang = page.path.match?(/\/manuals\/1\.0\/#{Regexp.escape(lang)}\/[^\/]+\.md$/)
        is_correct_layout = (lang == 'en' && page.data['layout'] == 'docs-en') || (lang == 'ja' && page.data['layout'] == 'docs-ja')
        is_not_index = !page.path.end_with?('/index.md')
        is_not_convention = !page.path.include?('/convention/')
        is_not_excluded = page.data['sidebar'] != false
        has_title = page.data['title']
        
        result = is_manual && is_correct_lang && is_correct_layout && is_not_index && is_not_convention && is_not_excluded && has_title
        
        if result
          puts "SidebarData: Including #{lang}: #{page.path} -> '#{page.data['title']}' (layout: #{page.data['layout']})"
        elsif is_manual && is_correct_lang
          puts "SidebarData: Excluding #{lang}: #{page.path} -> '#{page.data['title']}' (layout: #{page.data['layout']}) - layout_check: #{is_correct_layout}"
        end
        
        result
      end

      puts "SidebarData: Found #{manual_pages.length} pages for #{lang}"

      # Sort by filename number
      manual_pages.sort! do |a, b|
        a_match = a.basename_without_ext.match(/^(\d+)-/)
        b_match = b.basename_without_ext.match(/^(\d+)-/)
        
        if a_match && b_match
          a_match[1].to_i <=> b_match[1].to_i
        elsif a_match
          -1
        elsif b_match
          1
        else
          a.basename_without_ext <=> b.basename_without_ext
        end
      end

      manual_pages.map do |page|
        {
          'title' => page.data['title'],
          'url' => page.url,
          'permalink' => page.data['permalink']
        }
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SidebarData)