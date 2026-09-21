# Index the raw BibTeX entries used by the publication cards.
#
# Publication metadata lives in papers.bib, while bibtex.bib contains the
# citation users should copy. Keeping these files separate prevents site-only
# fields such as pdf, html, and abbr from leaking into the citation.
module BibtexEntries
  module_function

  def parse(source)
    entries = {}
    position = 0

    while (start = source.index('@', position))
      opening_brace = source.index('{', start)
      break unless opening_brace

      depth = 0
      closing_brace = nil
      index = opening_brace

      while index < source.length
        character = source[index]
        depth += 1 if character == '{'
        depth -= 1 if character == '}'

        if depth.zero?
          closing_brace = index
          break
        end
        index += 1
      end

      break unless closing_brace

      entry = source[start..closing_brace].strip
      key = entry.match(/\A@[^\{]+\{\s*([^,\s]+)/)&.captures&.first
      entries[key] = entry if key
      position = closing_brace + 1
    end

    entries
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  bibtex_path = File.join(site.source, '_bibliography', 'bibtex.bib')
  next unless File.file?(bibtex_path)

  source = File.read(bibtex_path, encoding: 'UTF-8')
  site.data['bibtex_entries'] = BibtexEntries.parse(source)
end
