module Jekyll
  class SidebarGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      puts "SidebarGenerator: Starting generation..."
      # Generate sidebar data for each language
      ['en', 'ja'].each do |lang|
        puts "SidebarGenerator: Generating for language: #{lang}"
        generate_sidebar_data(site, lang)
      end
      puts "SidebarGenerator: Generation complete"
    end

    private

    def generate_sidebar_data(site, lang)
      puts "SidebarGenerator: Looking for pages in language: #{lang}"
      puts "SidebarGenerator: Total pages found: #{site.pages.length}"
      
      manual_pages = site.pages.select do |page|
        is_manual = page.data['category'] == 'Manual'
        is_lang_path = page.path.include?("/manuals/1.0/#{lang}/")
        is_not_index = !page.path.end_with?('/index.md')
        is_not_convention = !page.path.include?('/convention/')
        is_not_excluded = page.data['sidebar'] != false
        has_title = page.data['title']
        
        if is_lang_path
          puts "SidebarGenerator: Found file: #{page.path} - Manual:#{is_manual} Title:'#{page.data['title']}'"
        end
        
        is_manual && is_lang_path && is_not_index && is_not_convention && is_not_excluded && has_title
      end
      
      puts "SidebarGenerator: Found #{manual_pages.length} manual pages for #{lang}"

      # Sort by filename number (01-, 02-, etc.)
      manual_pages.sort! do |a, b|
        a_match = a.basename_without_ext.match(/^(\d+)-/)
        b_match = b.basename_without_ext.match(/^(\d+)-/)
        
        if a_match && b_match
          a_match[1].to_i <=> b_match[1].to_i
        elsif a_match
          -1  # numbered files come first
        elsif b_match
          1
        else
          a.basename_without_ext <=> b.basename_without_ext
        end
      end

      # Create sidebar data
      sidebar_items = manual_pages.map do |page|
        {
          'title' => page.data['title'],
          'url' => page.url,
          'permalink' => page.data['permalink']
        }
      end

      # Store in site data
      site.data["sidebar_#{lang}"] = sidebar_items
      puts "SidebarGenerator: Stored #{sidebar_items.length} items for sidebar_#{lang}"
    end
  end
end